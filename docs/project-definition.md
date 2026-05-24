# Project Definition

## Goal

Create a private VPN hosted on a Hetzner Cloud VPS in Germany, using OpenVPN Community Edition and manual configuration managed by this repository.

## Current Server Plan

- Provider: Hetzner Cloud.
- Region: Germany.
- Location: Falkenstein is acceptable; Nuremberg is also acceptable if capacity or latency is better.
- Server type: CX23, shared cost-optimized.
- CPU/RAM/Disk: 2 vCPU, 4 GB RAM, 40 GB SSD.
- Architecture: x86 Intel/AMD.
- Operating system: Ubuntu 24.04 LTS.
- Networking: public IPv4 and public IPv6.
- SSH access: SSH key only.
- Volumes: none for v1.
- Backups: optional; if disabled, VPN configuration and certificate backup must be handled separately.
- Labels: recommended after creation, for example `env=prod`, `role=vpn`, `region=de`.

## VPN Choice

Use OpenVPN Community Edition, not OpenVPN Access Server.

Reasons:
- No paid concurrent-connection licensing.
- Full control of configuration.
- Smaller public web surface because there is no official admin UI to expose.

Tradeoffs:
- More manual certificate, user, routing, and revocation management.
- No official OpenVPN web admin interface.
- Any future admin UI must be treated as an additional attack surface.

## Exposure Model

Default posture: expose only what is required for SSH administration and VPN client connectivity.

Planned public services:
- SSH on TCP 22, restricted by firewall to trusted source IPs where practical.
- OpenVPN on UDP 1194.

Optional later:
- OpenVPN TCP fallback on TCP 443 if client networks block UDP 1194.
- DNS hostname for client profiles, once the server IP is stable.

Not planned:
- Public OpenVPN admin UI.
- Public web dashboard.

If an admin UI is added later, bind it to localhost and access it through an SSH tunnel.

## Local Private Material

Private keys, client profiles, server IP notes, provider details, and generated VPN configuration belong in `artifacts/private/`, which is ignored by Git.

The SSH public key for initial server creation should be stored at:

```text
local/ssh/id_ed25519.pub
```

The matching private key should be stored locally at:

```text
local/ssh/id_ed25519
```
