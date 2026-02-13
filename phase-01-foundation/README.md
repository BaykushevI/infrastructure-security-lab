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