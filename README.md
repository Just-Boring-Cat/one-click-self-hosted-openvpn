# one-click-self-hosted-openvpn

<p align="center">
  <img alt="Visibility" src="https://img.shields.io/badge/visibility-private-555555">
  <img alt="Status" src="https://img.shields.io/badge/status-discovery-1f6feb">
  <img alt="License" src="https://img.shields.io/badge/license-private-lightgrey">
</p>

Agent-friendly OpenVPN Community Edition setup for a private VPS-hosted VPN.

## Current Status

The first Hetzner-hosted VPN server is configured and documented. The current work is turning that tested setup into a public-safe, provider-extensible one-click installer.

## Scope

Current scope:
- Maintain the local project repository.
- Configure a private OpenVPN Community Edition server on a Hetzner Cloud VPS in Germany.
- Expose the smallest practical public attack surface.
- Keep private keys, client profiles, server IPs, and generated configs out of Git.
- Build an agent-friendly public setup flow with provider modules and local-only output folders.

Not defined yet:
- DNS, monitoring, backup, and access-control model.
- Full idempotent one-click installer.
- Additional provider modules beyond Hetzner.

## Docs

- [docs/README.md](docs/README.md) - project documentation map.
- [docs/project-definition.md](docs/project-definition.md) - current project definition and server choices.
- [docs/agent-setup.md](docs/agent-setup.md) - AI agent setup instructions.
- [docs/openvpn-runbook.md](docs/openvpn-runbook.md) - OpenVPN server state, operations, and verification commands.
- [docs/publication-plan.md](docs/publication-plan.md) - public project packaging plan.
- [docs/tasks.md](docs/tasks.md) - deferred and upcoming tasks.
- [docs/decisions.md](docs/decisions.md) - decision log.
- [docs/session-log.md](docs/session-log.md) - lightweight session history.
- [artifacts/README.md](artifacts/README.md) - artifact and secret-handling policy.
- [providers/README.md](providers/README.md) - provider module structure.
- [scripts/README.md](scripts/README.md) - setup script notes.

## Local Setup

```bash
cp .env.example .env
scripts/setup-openvpn.sh --requirements
scripts/setup-openvpn.sh --collect
scripts/setup-openvpn.sh --check
```

Private runtime files belong under `local/`.

## Confidentiality And Safety

Do not commit credentials, VPN keys, VPS IP addresses, client profiles, private DNS records, provider tokens, logs with client addresses, or generated server configuration containing secrets.

Private runtime material belongs under ignored paths such as `local/` and `artifacts/private/`.

## License

Private project. See [LICENSE.md](LICENSE.md).
