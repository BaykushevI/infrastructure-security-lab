# Phase 02 – Enumeration (LAN)

Goal: discover LAN hosts and enumerate exposed services in a repeatable, evidence-driven way, without leaking sensitive identifiers.

## Scope

- LAN host discovery (safe discovery scans)
- Router service enumeration (LAN-side)
- Evidence handling:
  - `evidence/raw/` (local only, gitignored)
  - `evidence/sanitized/` (committed, redacted)

## Key learnings (what we actually observed)

### 1) Host discovery is method-dependent
We tested different discovery methods and saw that results vary depending on device state and network behavior:

- ICMP echo (classic ping) may fail when devices sleep / power-save / block ICMP
- TCP “ping” (SYN probes to common ports) depends on whether those ports respond
- ARP discovery (`-PR`) works best on the local L2 segment (same subnet), even when ICMP is blocked

### 2) Device sleep / power-save affects visibility
During testing, a mobile device could:
- respond consistently while active/unlocked
- start timing out when locked / sleeping
This is expected behavior: the OS may power down radios/services and stop responding to certain probes.

### 3) “Flat LAN” means lateral visibility
When the router is in Router Mode and client isolation is not enabled, devices on the same subnet can typically see and probe each other (subject to OS firewalls).
This is convenient, but increases blast radius if one endpoint is compromised.

## Commands used

### LAN discovery
nmap -sn <LAN_CIDR>
nmap -sn -PR <LAN_CIDR>
nmap -sn -PS22,80,443 <LAN_CIDR>
arp -a