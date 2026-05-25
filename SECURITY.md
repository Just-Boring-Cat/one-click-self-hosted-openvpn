# Security Policy

## Supported Scope

This repository documents and automates private OpenVPN Community Edition setups on VPS providers.

The first tested provider is Hetzner Cloud. The first tested operating system is Ubuntu 24.04 LTS. Other provider and OS modules are community extensibility targets until they are explicitly marked tested.

## Reporting A Vulnerability

Report security concerns through the repository's configured private vulnerability reporting channel, if available. If private vulnerability reporting is not available, contact the maintainer without publishing exploit details in an issue.

Do not open public issues containing:

- private keys,
- generated `.ovpn` profiles,
- real server IPs tied to a private deployment,
- provider tokens,
- logs with client addresses,
- CA material,
- exploit details that put active deployments at risk.

## Security Boundaries

This project can help configure a private VPN server, but it does not guarantee anonymity, perfect security, legal compliance, uptime, or protection from a compromised VPS provider or client device.

Operators remain responsible for:

- provider account security,
- SSH key protection,
- client profile distribution,
- CA backup and revocation,
- operating system updates,
- firewall review,
- legal and acceptable-use compliance.

## Public Release Checklist

Before publishing a release, verify that the release tree excludes:

- `.env`,
- `.context/`,
- `.codex/`,
- `AGENTS.override.md`,
- `local/ssh/*`,
- `local/clients/*`,
- `local/server/*`,
- `local/logs/*`,
- `local/backups/*`,
- `artifacts/private/`,
- generated `.ovpn` files,
- private keys,
- CA material,
- server IP notes.
