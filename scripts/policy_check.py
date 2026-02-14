from __future__ import annotations

import re
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    print("Missing dependency: pyyaml. Install with: pip3 install pyyaml", file=sys.stderr)
    sys.exit(3)

OPEN_LINE = re.compile(r"^(?P<port>\d+)/(tcp|udp)\s+open\s+(?P<service>\S+)", re.MULTILINE)

def parse_open_ports(nmap_text: str) -> list[int]:
    ports: list[int] = []
    for m in OPEN_LINE.finditer(nmap_text):
        ports.append(int(m.group("port")))
    return sorted(set(ports))

def main() -> int:
    if len(sys.argv) != 3:
        print("Usage: policy_check.py <policy.yaml> <sanitized_router_sV.txt>", file=sys.stderr)
        return 3
    
    policy_path = Path(sys.argv[1])
    evidence_path = Path(sys.argv[2])

    policy = yaml.safe_load(policy_path.read_text())
    txt = evidence_path.read_text(errors="ignore")

    open_ports = parse_open_ports(txt)

    forbidden = set(policy["router"]["forbidden_tcp_ports"])
    allowed = set(policy["router"]["allowed_tcp_ports"])
    notes = policy["router"].get("notes", {})

    violations = [p for p in open_ports if p in forbidden]
    unknown = [p for p in open_ports if (p not in allowed and p not in forbidden)]

    # Report (markdown to stdout)
    print("# Policy Check Report\n")
    print(f"Evidence file: `{evidence_path.as_posix()}`\n")
    print("## Detected open ports\n")
    if open_ports:
        print(", ".join(str(p) for p in open_ports))
    else:
        print("(none)")
    print("\n## Violations\n")
    if violations:
        for p in violations:
            note = notes.get(str(p), "")
            print(f"- **{p}/tcp** (forbidden) {('- ' + note) if note else ''}")
    else:
        print("- None")

    print("\n## Unknown / Review\n")
    if unknown:
        for p in unknown:
            print(f"- **{p}/tcp** (not in allowed/forbidden list)")
    else:
        print("- None")

    # Exit codes: 0 ok, 2 violations
    return 2 if violations else 0


if __name__ == "__main__":
    raise SystemExit(main())