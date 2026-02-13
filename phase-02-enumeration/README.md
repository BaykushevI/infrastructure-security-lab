# Phase 02 – Enumeration

Goal: discover hosts and enumerate exposed services in a repeatable and evidence-driven way.

## Scope

- LAN host discovery (safe scan)
- Router service enumeration (LAN-side)
- Evidence handling:
  - `evidence/raw/` (gitignored)
  - `evidence/sanitized/` (committed)

## Commands used

- Host discovery: `nmap -sn <LAN_CIDR>`
- Router enumeration: `nmap -sV <ROUTER_IP>`

## Output artifacts

- Raw outputs: stored locally for troubleshooting
- Sanitized outputs: published for transparency without leaking identifiers