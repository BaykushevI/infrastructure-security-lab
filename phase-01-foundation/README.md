# Phase 01 – Infrastructure Baseline

## Physical / Logical Layout

- ISP Router (192.168.1.1)
- AX1800 Router (LAN: 192.168.0.1)
- Client: macOS (192.168.0.2)

## Network Segments

- Internal LAN: 192.168.0.0/24
- Upstream ISP LAN: 192.168.1.0/24

## Routing Path (based on traceroute)

1. 192.168.0.1 (AX1800)
2. 192.168.1.1 (ISP router)
3. ISP backbone
4. Internet

## Observations

- Double NAT detected
- DNS forwarded via 192.168.0.1
- Subnet mask: /24

## Trust Zones

### Zone 1 – Internet
Untrusted external network.

### Zone 2 – ISP Network (192.168.1.0/24)
Upstream private segment controlled by ISP hardware.

### Zone 3 – Internal LAN (192.168.0.0/24)
Local network behind AX1800 router (Router mode).

### Observations

- Double NAT detected.
- AX1800 acts as internal boundary firewall.
- ISP router acts as external boundary.

## Asset Classification (Initial)

This is an initial classification and will be refined in later phases.

| Asset / Device Type | Criticality | Why it matters | Examples |
|---|---|---|---|
| Personal workstation | Critical | Personal data, credentials, access to accounts | macOS laptop/desktop |
| Work laptop | Critical | Corporate access, sensitive data, compliance impact | company-managed laptop |
| Mobile phones | High | MFA tokens, personal identity, apps, photos | iPhone / Android |
| NAS / Home server | High | Data storage, backups, media, potential pivot | NAS, Raspberry Pi server |
| Gaming consoles | Medium | Lower data value but can be a foothold | PS4/PS5 |
| IoT devices | Low / Untrusted | Often weak security; common entry point | TV, cameras, smart plugs |