<h1 align="center">one-click-self-hosted-openvpn</h1>

<p align="center">
  <img alt="Project" src="https://img.shields.io/badge/project-agent--ready%20OpenVPN-1f6feb">
  <img alt="VPN" src="https://img.shields.io/badge/vpn-OpenVPN%20Community%20Edition-2ea043">
  <img alt="Provider" src="https://img.shields.io/badge/provider-Hetzner%20tested-ff6f00">
  <img alt="Status" src="https://img.shields.io/badge/status-active%20build-8957e5">
  <img alt="License" src="https://img.shields.io/badge/license-MIT-lightgrey">
</p>

Set up your own private OpenVPN server on a VPS, with an AI agent guiding the configuration instead of asking you to copy random commands from a blog post.

This project is for people who want a small, self-hosted VPN that they control: your VPS, your SSH keys, your OpenVPN profiles, your firewall rules. The first tested deployment path is Hetzner Cloud in Germany, and the repo is being structured so more providers and operating systems can be added over time.

## Why This Exists

Commercial VPNs are convenient, but shared exit IPs can be noisy, blocked, or flagged by websites. A private VPS-hosted VPN gives you a dedicated server, predictable configuration, and direct control over who can connect.

This repository aims to make that setup repeatable:

- Agent-led setup flow for coding and operations agents.
- OpenVPN Community Edition, configured directly without a public admin UI.
- Provider modules, starting with Hetzner Cloud.
- Secure-by-default handling for SSH keys, client profiles, logs, and server notes.
- Local output folders that keep private runtime files out of Git.
- Documentation written so users can run the setup themselves or ask an AI agent to do it carefully.

## What You Get

- A private OpenVPN server on your own VPS.
- A generated client `.ovpn` profile for your device.
- SSH-based administration only.
- Minimal public exposure: SSH plus the OpenVPN port you choose.
- Firewall and hardening guidance.
- A repeatable setup path that can later support more providers.

## Current State

The first real deployment has been completed and tested on a Hetzner VPS. The current public work is turning that proven setup into a clean, agent-friendly project that can be used by other operators.

Implemented now:

- Agent setup contract through `.env.example`.
- Guarded setup helper in `scripts/setup-openvpn.sh`.
- Provider documentation for Hetzner.
- Public-safe local folder layout.
- OpenVPN runbook and security documentation.
- OS support matrix instead of assuming every server is Ubuntu.

Planned next:

- Full provider modules.
- More operating system modules.
- More idempotent setup steps.
- Optional harder-to-detect OpenVPN profiles such as UDP 443, TCP 443 fallback, and stronger TLS wrapping.
- Provider API automation where supported.
- Community provider and OS contributions.

## Quick Start For An AI Agent

Give your agent this instruction:

```text
Use this repository to configure my private OpenVPN server. Read docs/agent-playbook.md and docs/agent-setup.md first. Help me fill .env from .env.example, inspect the server over SSH, choose the correct provider and OS path, run the setup helpers when needed, and place generated client profiles only under local/clients/.
```

The helper script supports the early setup flow:

```bash
cp .env.example .env
scripts/setup-openvpn.sh --requirements
scripts/setup-openvpn.sh --collect
scripts/setup-openvpn.sh --check
scripts/setup-openvpn.sh --inspect
scripts/setup-openvpn.sh --plan
```

The script is intentionally not the whole product. The agent should read the docs, inspect the server, choose the right path, run commands deliberately, and stop when a security-sensitive decision needs operator confirmation.

## What The User Must Provide

- VPS provider.
- Server public IP address or hostname.
- SSH user.
- SSH private key path.
- Operating system and version.
- Desired first OpenVPN client name.
- Whether the provider firewall is already configured.

Real values belong in `.env`, which is ignored by Git.

## Security Model

This project is designed for a small private VPN, not a public VPN service.

Defaults and guardrails:

- No public OpenVPN admin UI.
- No provider tokens committed to the repo.
- No generated `.ovpn` profiles committed to the repo.
- No SSH private keys committed to the repo.
- No real server IPs committed to public docs.
- SSH access is verified before hardening.
- The OS is inspected before package installation.
- Private runtime material goes under ignored `local/` paths.

This setup does not guarantee anonymity, legal compliance, or protection from a compromised VPS provider, client device, or operator account. Read [SECURITY.md](SECURITY.md) before using this on an important server.

## Repository Layout

```text
.
+-- .env.example              # public input contract
+-- docs/                     # runbooks, agent instructions, decisions
+-- local/                    # ignored private runtime workspace
|   +-- ssh/                  # SSH keys
|   +-- clients/              # generated .ovpn profiles
|   +-- server/               # local inspection notes
|   +-- logs/                 # local setup logs
|   +-- backups/              # local-only backups
+-- providers/                # provider-specific instructions
|   +-- hetzner/
|   +-- _template/
+-- scripts/
    +-- setup-openvpn.sh      # guarded helper used by the agent
```

## Documentation

- [docs/agent-playbook.md](docs/agent-playbook.md) - step-by-step agent workflow.
- [docs/agent-setup.md](docs/agent-setup.md) - required inputs, private output paths, and execution rules.
- [docs/openvpn-runbook.md](docs/openvpn-runbook.md) - OpenVPN operations and verification.
- [docs/os-support.md](docs/os-support.md) - supported and planned operating systems.
- [providers/README.md](providers/README.md) - provider module structure.
- [providers/hetzner/README.md](providers/hetzner/README.md) - Hetzner setup notes.
- [scripts/README.md](scripts/README.md) - setup helper details.
- [docs/pr-review-security.md](docs/pr-review-security.md) - safe PR review rules for humans and AI agents.
- [SECURITY.md](SECURITY.md) - security boundaries and reporting guidance.

## Roadmap

The project is being built around GitHub issues so users and contributors can follow what is ready and what still needs work:

- Agent-led OpenVPN setup modules.
- Provider API automation starting with Hetzner Cloud.
- Optional stealth-oriented OpenVPN profiles.
- OS modules beyond Ubuntu and Debian.
- Public release checklist and clean-history policy.

## Contributing

Contributions are welcome. Useful contributions include new VPS provider modules, operating system support, firewall patterns, OpenVPN configuration profiles, validation improvements, and documentation that helps AI agents perform the setup safely.

All changes to `main` should go through pull requests. Provider and OS contributions should clearly say what was tested, which region or image was used, what firewall rules are required, and what limitations remain.

Start with [CONTRIBUTING.md](CONTRIBUTING.md) and the provider template in [providers/_template/](providers/_template/).

## License

MIT License. See [LICENSE.md](LICENSE.md).
