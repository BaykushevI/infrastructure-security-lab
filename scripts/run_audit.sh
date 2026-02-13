#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Targets files:
# - policy/targets.local.yaml  (real values, gitignored)
# - policy/targets.example.yaml (sanitized example, committed)
TARGETS_LOCAL="policy/targets.local.yaml"
TARGETS_EXAMPLE="policy/targets.example.yaml"

# Choose targets file: local > example
TARGETS_FILE="$TARGETS_EXAMPLE"
if [[ -f "$TARGETS_LOCAL" ]]; then
  TARGETS_FILE="$TARGETS_LOCAL"
fi

RAW_DIR="evidence/raw"
SAN_DIR="evidence/sanitized"
REPORT_DIR="evidence/sanitized/reports"

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "ERROR: missing command: $1" >&2
    exit 3
  }
}

echo "[*] Preflight checks"
require_cmd nmap
require_cmd python3

if [[ -z "${VIRTUAL_ENV:-}" ]]; then
  echo "WARN: VIRTUAL_ENV is not set (venv not active)."
  echo "      Activate it with: source .venv/bin/activate"
  echo "      (continuing anyway, but python deps may be missing)"
fi

mkdir -p "$RAW_DIR" "$SAN_DIR" "$REPORT_DIR"

# Read YAML targets via Python (PyYAML)
read_targets_yaml() {
  python3 - "$TARGETS_FILE" <<'PY'
import sys
from pathlib import Path
try:
  import yaml
except Exception as e:
  print("ERROR: PyYAML not available. Activate venv and run: pip install pyyaml", file=sys.stderr)
  sys.exit(3)

p = Path(sys.argv[1])
data = yaml.safe_load(p.read_text()) or {}
lan = data.get("lan_cidr", "")
rip = data.get("router_ip", "")
print(lan)
print(rip)
PY
}

vals="$(read_targets_yaml)" || exit $?
LAN_CIDR="$(printf "%s" "$vals" | sed -n '1p')"
ROUTER_IP="$(printf "%s" "$vals" | sed -n '2p')"

if [[ -z "$LAN_CIDR" || -z "$ROUTER_IP" ]]; then
  echo "ERROR: Missing lan_cidr or router_ip in $TARGETS_FILE" >&2
  exit 3
fi

echo "[*] Using targets file: $TARGETS_FILE"
echo "[*] LAN_CIDR=$LAN_CIDR"
echo "[*] ROUTER_IP=$ROUTER_IP"

ts="$(date +%Y%m%d-%H%M%S)"

echo "[*] Scanning LAN hosts (raw) -> $RAW_DIR/lan_hosts_${ts}.txt"
nmap -sn "$LAN_CIDR" --stats-every 5s > "$RAW_DIR/lan_hosts_${ts}.txt"

echo "[*] Scanning router services (raw) -> $RAW_DIR/router_sV_${ts}.txt"
nmap -sV "$ROUTER_IP" --stats-every 5s > "$RAW_DIR/router_sV_${ts}.txt"

echo "[*] Sanitizing evidence"
python3 scripts/redact.py < "$RAW_DIR/lan_hosts_${ts}.txt" > "$SAN_DIR/lan_hosts.txt"
python3 scripts/redact.py < "$RAW_DIR/router_sV_${ts}.txt"  > "$SAN_DIR/router_sV.txt"

echo "[*] Running policy check -> $REPORT_DIR/policy_report.md"
set +e
python3 scripts/policy_check.py policy/policy.yaml "$SAN_DIR/router_sV.txt" \
  | tee "$REPORT_DIR/policy_report.md"
policy_rc=${pipestatus[1]:-${PIPESTATUS[0]:-0}}
set -e

echo "[*] Policy check exit code: $policy_rc"
exit "$policy_rc"