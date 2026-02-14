# Policy Check Report

Evidence file: `evidence/sanitized/router_sV.txt`

## Detected open ports

22, 23, 53, 80, 1900

## Violations

- **23/tcp** (forbidden) - Telnet is plaintext and should be disabled.
- **1900/tcp** (forbidden) - UPnP can expose services automatically.

## Unknown / Review

- None
