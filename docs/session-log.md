# Session Log

## 2026-05-24

- Initialized the local repository.
- Initialized the local repository and development guidance.
- Added neutral baseline files before project definition.
- Defined the initial VPN setup: Hetzner Cloud Germany, CX23, Ubuntu 24.04 LTS, public IPv4 plus IPv6, SSH key access, and OpenVPN Community Edition.
- Deferred Hetzner firewall creation until after the server exists and recorded the firewall backlog.
- Generated a project-specific SSH key pair under `artifacts/private/ssh/`.
- Created maintainer guidance for future public-release and paid-service planning.
- Added the Hetzner firewall runbook with the v1 allow-list policy.
- Configured the VPS with OpenVPN Community Edition, Easy-RSA PKI, nftables forwarding/NAT, fail2ban, unattended upgrades, a non-root `vpnadmin` account, and a first private client profile.
- Added private `.env` connection details, a public `.env.example`, an ignored `local/` runtime workspace, provider module folders, and agent setup instructions for the future public packaging flow.
- Added public-release guardrails through `SECURITY.md`, `docs/publication-plan.md`, and script/provider folder documentation.
- Added setup-script intake commands so an AI agent can show requirements, collect `.env` values, and validate SSH access before running the installer.
- Confirmed the generated OpenVPN client profile works from the client app.
- Documented VPN detectability, stealth options, and performance tradeoffs.
- Prepared public-facing README and ignores so local agent context stays out of the GitHub remote.
- Created the private GitHub repository and pushed a clean public-safe `main` branch.

Open questions:
- Decide whether backups are enabled in Hetzner or handled separately.
- Decide whether TCP 443 fallback is needed after testing UDP 1194 from target networks.
- Convert the tested setup flow into an idempotent installer.
