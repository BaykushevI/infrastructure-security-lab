Phase 03 – Risk Analysis & Segmentation Validation

Executive Summary

This phase converts technical enumeration findings (Phase 02) into a structured risk view for a home network environment.

Key findings:
	•	Router exposes legacy administrative services (Telnet)
	•	UPnP is enabled and increases lateral exposure risk
	•	Guest isolation is enforced via firewall rules (validated)
	•	No VLAN-based segmentation available on the router model (TP-Link EX220)

Overall posture: Moderate risk, high improvement potential

⸻

1️⃣ Evidence Inputs

From Phase 02:
	•	evidence/sanitized/router_sV.txt
	•	evidence/sanitized/lan_hosts.txt
	•	evidence/sanitized/reports/policy_report.md

Additional validation:
	•	Manual segmentation testing from Guest SSID
	•	ARP and Nmap validation
	•	Behavioral observation (device responsiveness)

⸻

2️⃣ Current Network Architecture

Router: TP-Link EX220 (AX1800)

Topology:
Internet
   │
[Router]
   ├── Main LAN (192.168.0.0/24)
   ├── Guest SSID (firewall isolated)
   └── NAT to WAN

Important:
	•	Single subnet
	•	No VLAN separation
	•	Guest isolation implemented via firewall policy (Layer 3 control)

                         Internet
                             │
                             │ (NAT)
                    ┌──────────────────┐
                    │  TP-Link EX220   │
                    │  192.168.0.1     │
                    └──────────────────┘
                       │          │
         ┌─────────────┘          └───────────────┐
         │                                         │
   Main LAN (192.168.0.0/24)                 Guest SSID
   Flat network                               Firewall isolated
   ├── Mac (trusted)                          └── Internet only
   ├── iPhone
   ├── Watch
   └── IoT devices

⸻

3️⃣ Router Exposed Services (LAN-side)
Port Service Risk
23/tcp Telnet Critical – plaintext admin surface
1900/tcp UPnP High – dynamic port mapping risk
22/tcp SSH Medium – depends on config
53/tcp DNS Medium – core infra component
80/443 Admin UI Medium – depends on auth + firmware

4️⃣ Segmentation Validation

Test performed

From Guest SSID:
	•	Attempted ICMP to 192.168.0.2 (trusted device)
	•	Attempted LAN scanning
	•	Attempted service probing

Result
	•	❌ Guest → LAN blocked
	•	❌ Guest → Router LAN services blocked (except WAN access)
	•	✔ Guest → Internet allowed

Interpretation

Router implements:

Firewall-based isolation (one-way policy)

This is NOT VLAN segmentation but is effective for home-level risk reduction.

⸻

5️⃣ Threat Modeling (Home Context)

Assets
	•	Work laptop (corporate risk)
	•	Personal devices (financial risk)
	•	Phones (MFA compromise vector)
	•	IoT devices (weakest link)

Realistic attacker models
	1.	Compromised IoT device pivoting laterally
	2.	Guest device scanning LAN
	3.	Malware on one endpoint
	4.	WAN exposure via UPnP misconfiguration

⸻

6️⃣ Quantitative Risk Matrix

Risk = Impact (1–5) × Likelihood (1–5)
Finding Impact Likelihood Score Severity
Telnet enabled 5 4 20 Critical
UPnP enabled 4 3 12 High
Admin UI LAN-accessible 4 3 12 High
SSH enabled 3 2 6 Medium
DNS exposed internally 3 3 9 Medium
Guest isolation validated Risk reduced — — Positive

7️⃣ Security Posture Summary

Before Guest Validation
	•	Flat network assumption
	•	High lateral movement potential

After Validation
	•	Guest → LAN pivot blocked
	•	IoT isolation possible via Guest SSID reuse
	•	Lateral risk partially mitigated

Remaining issues:
	•	Telnet exposure
	•	UPnP exposure
	•	No true segmentation (VLAN)

⸻

8️⃣ Prioritized Hardening Backlog

P0 – Immediate
	•	Disable Telnet
	•	Disable UPnP

P1 – Administrative Hardening
	•	Strong unique admin password
	•	Disable WAN remote management
	•	Firmware update
	•	Disable WPS

P2 – Segmentation Strategy
	•	Move IoT devices to Guest SSID
	•	Keep work/personal on Main LAN

P3 – Monitoring & Drift
	•	Scheduled audit execution
	•	Track new open ports
	•	Track new hosts

⸻

9️⃣ Target State (Definition of Done)

✔ Telnet disabled
✔ UPnP disabled
✔ Admin interface restricted
✔ IoT isolated
✔ Repeatable audit pipeline
✔ Drift detection operational

⸻

🔟 Maturity Assessment
Domain Status
Enumeration Automated
Risk scoring Defined
Segmentation Basic firewall isolation
Monitoring Script-based
Enterprise readiness Partial

