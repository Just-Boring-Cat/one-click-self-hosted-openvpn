# Artifacts Policy

This project may eventually produce deployment packages, diagrams, VPN client profiles, server configuration, or operational runbooks.

Do not commit generated secrets, private keys, provider tokens, client profiles, raw logs, server configs containing secrets, or private VPS/network details.

Tracked artifacts should be reviewed, redacted where needed, and documented with source commit and verification notes.

Preferred public-package local workspace:

- `local/ssh/`
- `local/clients/`
- `local/server/`
- `local/logs/`
- `local/backups/`

Legacy/private project artifact folders:

- `artifacts/private/`
- `artifacts/generated/`
- `exports/`

Historical local private material may also exist under `artifacts/private/` in private workspaces. Do not publish those files.
