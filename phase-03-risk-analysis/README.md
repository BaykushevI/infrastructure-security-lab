# Phase 03 – Risk Analysis

Goal: convert enumeration evidence into a practical risk view and a prioritized hardening backlog.

Input comes from Phase 02 (`evidence/sanitized/*`, reports, and observed behavior).  
Output is a prioritized plan for Phase 04 (Hardening) and Phase 05 (Monitoring).

## Scope
- Identify exposed services on the router and key clients
- Map findings to realistic threats (home context)
- Assess impact/likelihood
- Produce a prioritized backlog (what to fix first and why)
- Define what “good” looks like (target state)

## Inputs (Evidence)
From Phase 02:
- `evidence/sanitized/router_sV.txt` – router service enumeration (LAN-side)
- `evidence/sanitized/lan_hosts.txt` – LAN discovery (sanitized)
- `evidence/sanitized/reports/policy_report.md` – policy violations summary

Observations:
- Phone responsiveness changes while locked / power saving
- Router UI shows connected clients (expected in home networks)

Note: raw evidence stays gitignored under `evidence/raw/`.

## Key Findings (current)

### Router exposed services (LAN-side)
| Port | Service | Why it matters | Risk |
|------|---------|----------------|------|
| 23/tcp | Telnet | plaintext admin surface; often weak/default creds; sniffable on LAN | High |
| 1900/tcp | UPnP | auto-exposure of services; can be abused for lateral movement or unwanted port mapping | Medium–High |
| 22/tcp | SSH (Dropbear) | legit admin channel but must be locked down; brute-force surface if reachable | Medium |
| 53/tcp | DNS (dnsmasq) | core infra component; poisoning/misconfig risks; LAN visibility | Medium |
| 80/443 | HTTP/HTTPS | admin UI attack surface; depends on auth/firmware/TLS | Medium |

## Threat Modeling (home context)

### Assets (what we protect)
- Work laptop: company data, credentials, VPN, email
- Personal Mac: passwords, banking, photos, backups
- Phones: MFA, iCloud/Google accounts, messages
- IoT: weakest devices, often never patched

### Trust zones
- Trusted: work + personal
- Semi-trusted: phones/tablets
- Untrusted / high-risk: IoT, guests

### Realistic attacker models
- Compromised IoT device inside LAN (most common)
- Guest device on Wi-Fi
- Malware on one endpoint scanning laterally
- (less likely) external attacker unless router exposes WAN management or UPnP maps ports

## Risk Assessment
Method: simple qualitative scoring (Impact × Likelihood).

| Finding | Impact | Likelihood | Notes |
|--------|--------|------------|------|
| Telnet enabled | High | High | plaintext + common router attack path |
| UPnP enabled | High | Medium | can open ports; also LAN abuse vectors |
| Router admin UI reachable on LAN | Medium | Medium | depends on creds, firmware, TLS |
| SSH enabled | Medium | Low–Medium | ok if key-only + LAN-only + strong config |
| Device discovery visible in router UI | Low | High | expected; risk depends on segmentation |

## Prioritized Backlog (what to do next)

### P0 (do first)
- Disable Telnet (23/tcp) or restrict to isolated admin VLAN only.
- Disable UPnP (1900/tcp / IGD behavior) unless explicitly needed.

### P1
- Harden router admin access:
  - strong unique admin password
  - disable remote management from WAN
  - restrict admin UI to a single trusted device if possible
- Update firmware; disable WPS; review firewall defaults.

### P2
- Segment network:
  - separate IoT/guest from trusted devices
  - client isolation for guest/IoT SSIDs

### P3
- Monitoring & drift:
  - keep running periodic scans + policy checks
  - alert on new open ports / new hosts

## Target State (definition of done for Phase 04/05)
- No Telnet; UPnP off
- Admin UI restricted + HTTPS only
- Separate Wi-Fi/segments for IoT/Guest
- Repeatable audit script produces:
  - sanitized evidence
  - policy report
  - drift signal (new services/hosts)

## Execution Notes (to be filled after we run)
Add here:
- commands executed
- timestamps (sanitized)
- outputs summary
- decisions made + reasoning