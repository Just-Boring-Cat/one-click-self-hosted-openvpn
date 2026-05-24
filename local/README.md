# Local Workspace

This folder is for private runtime files created while setting up or operating a VPN server.

The folder names are tracked so the structure is obvious, but generated secrets and profiles inside them are ignored by Git.

## Folders

- `ssh/` - SSH keys used to access the VPS.
- `clients/` - generated `.ovpn` client profiles.
- `server/` - private server notes, pulled configs, and inspection output.
- `logs/` - local setup logs and troubleshooting output.
- `backups/` - encrypted or local-only backups of CA/server material.

Do not publish private keys, generated profiles, server IP notes, logs with client addresses, CA material, or provider tokens.
