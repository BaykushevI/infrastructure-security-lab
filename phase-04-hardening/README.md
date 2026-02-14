# Phase 04 – Hardening

Goal: reduce attack surface and lateral movement opportunities while keeping home usability intact.

Input comes from Phase 02/03 evidence:
- `evidence/sanitized/router_sV.txt`
- `evidence/sanitized/lan_hosts.txt`
- `evidence/sanitized/reports/policy_report.md`
- Phase 03 risk matrix & backlog

Output:
- Applied hardening controls (documented + reproducible)
- Before/After evidence (sanitized)
- Validation checks (policy + drift + segmentation assertions)
- Updated risk score and remaining backlog

---

## Scope (what we will harden)

### Router surface (P0/P1)
- Disable Telnet (23/tcp)
- Disable UPnP / IGD (1900/tcp behavior)
- Admin UI hardening (HTTPS-only if possible, disable WAN admin, strong creds)
- Disable WPS
- Firmware update verification

### Network segmentation (P2)
- Guest network isolation (no LAN access; no client-to-client where possible)
- IoT placement strategy (IoT on Guest or separate SSID)
- Validate segmentation with repeatable checks (PASS/FAIL)

### Endpoint basics (P2)
- Client firewall baseline (Mac/work laptop)
- Minimize inbound sharing services (e.g., SMB/AirDrop scope)
- Document tradeoffs (AirPlay/Chromecast vs isolation)

---

## Controls Checklist

| Control | Target | Status | Evidence |
|---|---|---:|---|
| Disable Telnet | Router | ☐ | nmap before/after + policy report |
| Disable UPnP | Router | ☐ | router UI screenshot notes + behavior check |
| Disable WAN admin | Router | ☐ | router setting + external check (optional) |
| Admin UI hardened | Router | ☐ | HTTPS-only / access restrictions |
| Disable WPS | Router | ☐ | router setting |
| Firmware up to date | Router | ☐ | version recorded |
| Guest isolation on | Router | ☐ | segmentation validation |
| IoT moved to isolated zone | Devices | ☐ | inventory note |
| Baseline host firewall | Mac/Work | ☐ | commands + config summary |

---

## Evidence – Before (Baseline)

### Router ports (baseline)
- Source: `evidence/sanitized/router_sV.txt`
- Summary: (fill after capture)

### Policy report (baseline)
- Source: `evidence/sanitized/reports/policy_report.md`
- Exit code: (fill)

### Host discovery (baseline)
- Source: `evidence/sanitized/lan_hosts.txt`
- Observations: (fill)

---

## Implementation Notes (exact steps)

### 1) Disable Telnet
- UI path:
- Change:
- Verification:
  - `nmap -sV <ROUTER_IP>`
  - policy check report updated

### 2) Disable UPnP / IGD
- UI path:
- Change:
- Verification:
  - check router port mapping list (should not auto-create)
  - `nmap -sV <ROUTER_IP>` + behavior notes

### 3) Admin UI hardening
- UI path:
- Change(s):
- Verification:

### 4) Guest network isolation + IoT strategy
- UI path:
- Change(s):
- Verification:
  - `scripts/validate_segmentation.py` PASS/FAIL results

---

## Evidence – After (Post-hardening)

### Router ports (after)
- Source:
- Before vs After table:

### Policy report (after)
- Exit code:
- Violations remaining:

### Segmentation validation
- Result summary:
- Any exceptions/tradeoffs:

---

## Risk Score Update (Phase 03 -> Phase 04)

| Item | Before score | After score | Notes |
|---|---:|---:|---|
| Telnet | 20 |  | |
| UPnP | 12 |  | |
| Admin UI | 12 |  | |
| SSH | 6 |  | |
| DNS | 9 |  | |

---

## Remaining Backlog (feeds Phase 05 Monitoring)
- [ ] Drift alerts (new hosts/services)
- [ ] Central logging (syslog/export if possible)
- [ ] Scheduled audits + reporting