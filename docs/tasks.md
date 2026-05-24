# Tasks

## Server Creation

- Create a Hetzner Cloud server in Germany.
- Use Ubuntu 24.04 LTS.
- Use CX23 x86 Intel/AMD.
- Enable public IPv4 and public IPv6.
- Add the project SSH public key during server creation.
- Do not paste secrets or VPN certificates into cloud-init.

## Firewall Backlog

Create a Hetzner Cloud Firewall for this project after the server exists.

Initial inbound rules:
- Allow TCP 22 for SSH only from trusted source IPs where practical.
- Allow UDP 1194 from anywhere for OpenVPN.
- Optionally allow TCP 443 from anywhere only if we configure TCP fallback.
- Allow ICMP and ICMPv6 if available for diagnostics.
- Do not expose a public admin UI.

Initial outbound rules:
- Leave outbound unrestricted for setup and package updates.
- Revisit outbound restrictions after the VPN configuration is stable.

Runbook:
- Use [firewall.md](firewall.md) for the exact Hetzner Cloud Firewall configuration.

## OpenVPN Community Edition Setup

- [x] Install OpenVPN and Easy-RSA from Ubuntu packages.
- [x] Create a private certificate authority for this VPN.
- [x] Generate server certificates and keys.
- [x] Generate one client profile first.
- [x] Verify the generated profile can complete a server-side TLS handshake.
- [x] Configure packet forwarding and NAT.
- [x] Add host-level firewall rules after Hetzner firewall rules are defined.
- [x] Document client creation and revocation.
- [x] Verify client connectivity from the OpenVPN client app.

## Security Hardening

- [x] Disable password SSH login.
- [x] Disable root SSH login after `vpnadmin` key access is verified.
- [x] Enable unattended security updates.
- [x] Add fail2ban or equivalent SSH protection if SSH remains reachable from broad IP ranges.
- Keep private keys, `.ovpn` profiles, logs with client IPs, and server IP notes out of Git.
- Define a backup and recovery process for the CA, server configuration, and revocation list.

## Detection And Stealth

- [x] Document VPN detectability and performance tradeoffs.
- [ ] Add optional UDP `443` OpenVPN listener/profile.
- [ ] Add optional TCP `443` fallback profile for restrictive networks.
- [ ] Evaluate `tls-crypt-v2` for per-client control-channel keys.
- [ ] Evaluate stunnel/obfs-style transport as an advanced module, not the default.
- [ ] Add client-side DNS/WebRTC leak test instructions.

## Maintainer Monetization Workflow Refinement

- Refine the maintainer workflow while this VPN project is converted into a public, one-shot setup repo.
- Capture reusable patterns for public/private repo separation, safe one-click VPS automation, paid setup service positioning, sponsor/support calls to action, and customer handoff boundaries.
- Promote reusable improvements into the maintainer's shared local guidance outside the public repo.

## Public Project Packaging

- [x] Add `.env.example` as the public input contract.
- [x] Add ignored `.env` for private local connection details.
- [x] Add `local/` private workspace folders for SSH keys, client profiles, server notes, logs, and backups.
- [x] Add provider module structure starting with Hetzner and a provider template.
- [x] Add agent setup instructions.
- [x] Add security policy and publication plan.
- [x] Add setup-script intake commands for agent/user requirements collection.
- [ ] Promote the tested manual server setup into an idempotent one-click installer.
- [ ] Add provider-specific validation checks.
- [ ] Add GitHub issue for provider API automation, starting with Hetzner Cloud API.
- [ ] Add a public release checklist that removes `.context`, `.codex`, `AGENTS.override.md`, private local files, and generated profiles.
- [x] Push a clean public-safe branch to the private GitHub remote.
- [x] Add GitHub issue and pull request templates for the future public repo.
