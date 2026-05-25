# Agent Setup Instructions

This project is intended to be usable by an AI coding or operations agent, but the agent must preserve the security boundary between public instructions and private runtime material.

## Agent Goal

Configure a private OpenVPN Community Edition server on a VPS, then produce one or more client `.ovpn` profiles for the operator.

## Required Inputs

The operator must provide:

- VPS provider.
- Server public IP or hostname.
- SSH user.
- SSH private key path.
- Operating system and version.
- Desired first client profile name.
- Whether the provider firewall is already configured.

Use `.env.example` as the input contract. Real values belong in `.env`, which is ignored.

The setup script can show or collect the required values, validate SSH, inspect the server, and print the agent plan:

```bash
scripts/setup-openvpn.sh --requirements
scripts/setup-openvpn.sh --collect
scripts/setup-openvpn.sh --check
scripts/setup-openvpn.sh --inspect
scripts/setup-openvpn.sh --plan
```

## Private Output Locations

Write private generated material only under:

- `local/ssh/`
- `local/clients/`
- `local/server/`
- `local/logs/`
- `local/backups/`

Never write private generated material into tracked docs, scripts, provider modules, or README examples.

## Safe Execution Rules

- Read `.env` locally, but never print private keys or full client profiles in chat.
- Verify SSH access before changing SSH hardening.
- Inspect the OS before package installation; do not assume Ubuntu.
- Create or verify a non-root sudo admin user before disabling root SSH.
- Keep OpenVPN Community Edition as the default implementation.
- Do not expose a public admin UI.
- Keep outbound traffic unrestricted unless a complete outbound allow-list is explicitly designed.
- Fail closed if required inputs are missing.
- Record public-safe steps in docs, and private details in ignored local files.

## Expected Agent Flow

1. Run `scripts/setup-openvpn.sh --requirements`.
2. Help the user collect missing provider, server, SSH, firewall, and client-profile values.
3. Run `scripts/setup-openvpn.sh --collect` or write `.env` directly from the collected values.
4. Validate `.env` and local key paths with `scripts/setup-openvpn.sh --check`.
5. Inspect OS, interfaces, listeners, and existing services with `scripts/setup-openvpn.sh --inspect`.
6. Print the setup plan with `scripts/setup-openvpn.sh --plan`.
7. Connect to the server over SSH.
8. Install OS-appropriate OpenVPN, Easy-RSA, nftables/firewall, fail2ban, and unattended update packages.
9. Create Easy-RSA CA and server/client certificates.
10. Configure OpenVPN server on the selected protocol and port.
11. Configure IP forwarding and host firewall/NAT.
12. Harden SSH after non-root admin access is verified.
13. Pull generated `.ovpn` files into `local/clients/`.
14. Run server-side service and handshake validation.
15. Tell the operator how to test the profile in their OpenVPN app.

## Public Release Guardrails

Before preparing a public release, verify the release tree excludes:

- `.env`
- `.context/`
- `.codex/`
- `AGENTS.override.md`
- `local/ssh/*`
- `local/clients/*`
- `local/server/*`
- `local/logs/*`
- `local/backups/*`
- `artifacts/private/`
- generated `.ovpn` files
- private keys and CA material
