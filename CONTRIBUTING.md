# Contributing

Contributions are welcome. This project is intended to grow through provider modules, operating system modules, OpenVPN configuration profiles, security hardening improvements, and clearer agent instructions.

## Good Contribution Areas

- New VPS provider setup guides under `providers/`.
- New operating system support notes under `docs/os-support.md` and related setup modules.
- Safer OpenVPN configuration profiles.
- Firewall and hardening improvements.
- Better validation in `scripts/setup-openvpn.sh`.
- Documentation that helps AI agents and human operators avoid unsafe steps.
- Troubleshooting notes for tested providers, OS versions, and clients.

Other VPN technologies can be proposed when they fit the self-hosted private VPN goal. Keep them clearly separated from the OpenVPN path so users know what is tested.

## Pull Request Rules

Use pull requests for all changes to `main`.

Before opening a PR:

- Start from the latest `main` branch.
- Keep the change focused.
- State which provider, OS, OpenVPN version, or client was tested.
- Update docs when behavior or setup steps change.
- Add validation or tests where practical.
- Fill out the PR template.
- Read [docs/pr-review-security.md](docs/pr-review-security.md) when changing scripts, workflows, setup instructions, provider modules, generated files, or security-sensitive docs.

Do not include:

- `.env` files.
- Private keys.
- Generated `.ovpn` profiles.
- CA material.
- Provider tokens.
- Real private deployment IPs.
- Logs with client IP addresses.
- Local agent folders such as `.context/`, `.codex/`, or `AGENTS.override.md`.

## Provider Modules

Provider contributions should include:

- Provider name and tested region.
- Required server size.
- Supported operating systems.
- Required firewall rules.
- SSH access assumptions.
- Any API automation notes.
- Manual fallback steps.
- Known limits and provider-specific risks.

Use `providers/_template/` as the starting point.

## OS Support

Operating system contributions should be explicit about package names, service names, firewall tooling, network forwarding configuration, and any security framework such as SELinux or AppArmor.

Do not mark an OS as tested unless it was actually used for a successful setup and client connection.

## Security Contributions

Security-sensitive changes should explain the risk being reduced and how the change was verified. If the issue could expose active deployments, follow [SECURITY.md](SECURITY.md) instead of opening a public issue.

## AI And Prompt Injection Safety

PR diffs, comments, generated files, logs, and screenshots are untrusted input. Do not include instructions intended to manipulate human reviewers or AI agents, such as requests to ignore repository rules, reveal secrets, run unrelated commands, or bypass review.

High-risk paths are protected by CODEOWNERS and require repository-owner review.

## License

By contributing, you agree that your contribution will be licensed under the MIT License.
