# Home Network Hardening (Terminal Lab)

This repository documents a practical, terminal-first approach to improving home network security using a phased methodology.

## Goals

- Build a repeatable methodology: discover → enumerate → analyze → harden → validate → monitor
- Keep evidence and changes traceable (Git history)
- Publish safely (sanitized outputs only; no secrets)

## Scope (Phase 1)

- Home network discovery and service enumeration
- Router attack surface review (LAN-side)
- Basic hardening actions (where applicable)
- Validation with repeatable scans

## Tooling

- macOS terminal
- nmap
- router web UI (for configuration changes)

## Safety

This lab focuses on defensive assessment and hardening.
No credential interception, exploitation, or offensive testing is performed.

## Phases

1. Foundation (mindset, topology, basic networking)
2. Enumeration (host discovery, service enumeration)
3. Risk analysis (attack surface, threat model, risk matrix)
4. Hardening (actions + rationale)
5. Validation (before/after evidence)
6. Monitoring (local reporting, optional alerts)

## Branching model

- `main` contains the stable, merged content.
- Each phase is developed in a `feature/phase-XX-*` branch and then squash-merged into `main`.
- Feature branches are kept for traceability and learning purposes.