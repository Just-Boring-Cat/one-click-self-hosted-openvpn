# Scripts

Scripts in this folder are intended to become the public, repeatable setup interface for operators and AI agents.

## Current Script

```bash
./scripts/setup-openvpn.sh --requirements
./scripts/setup-openvpn.sh --collect
./scripts/setup-openvpn.sh --check
./scripts/setup-openvpn.sh --inspect
./scripts/setup-openvpn.sh --plan
```

The current script shows setup requirements, collects `.env` values, validates SSH access, inspects the server, and prints an agent execution plan. The setup itself remains agent-led so the agent can adapt to provider and OS differences.

## Script Rules

- Read private inputs from `.env`.
- Store generated private outputs under `local/`.
- Fail if required values are missing.
- Do not print private keys or full client profiles.
- Keep provider-specific logic in `providers/` or clearly marked sections.
- Keep common OpenVPN setup provider-neutral where practical.
- Do not assume Ubuntu unless inspection confirms an Ubuntu/Debian-family path.
