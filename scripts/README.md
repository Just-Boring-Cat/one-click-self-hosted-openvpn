# Scripts

Scripts in this folder are intended to become the public, repeatable setup interface for operators and AI agents.

## Current Script

```bash
./scripts/setup-openvpn.sh --requirements
./scripts/setup-openvpn.sh --collect
./scripts/setup-openvpn.sh --check
```

The current script shows setup requirements, collects `.env` values, validates SSH access, then points to the tested runbook. The next implementation step is to promote the manually validated Hetzner setup into an idempotent installer.

## Script Rules

- Read private inputs from `.env`.
- Store generated private outputs under `local/`.
- Fail if required values are missing.
- Do not print private keys or full client profiles.
- Keep provider-specific logic in `providers/` or clearly marked sections.
- Keep common OpenVPN setup provider-neutral where practical.
