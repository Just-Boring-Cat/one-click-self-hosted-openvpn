# Release Checklist

## Public Project Goal

Maintain a public, agent-friendly OpenVPN setup repository that helps operators configure their own private VPS-hosted VPN with secure defaults and clear provider modules.

The repository is public under the MIT License so users can use it, fork it, adapt it, and contribute provider, OS, and VPN configuration modules.

## Public Folder Structure

```text
.
+-- .env.example
+-- README.md
+-- SECURITY.md
+-- docs/
|   +-- agent-setup.md
|   +-- firewall.md
|   +-- openvpn-runbook.md
|   +-- release-checklist.md
+-- local/
|   +-- ssh/
|   +-- clients/
|   +-- server/
|   +-- logs/
|   +-- backups/
+-- providers/
|   +-- hetzner/
|   +-- _template/
+-- scripts/
    +-- setup-openvpn.sh
```

## Private Workspace

`local/` is the operator workspace. It exists in the public repo so users know where files belong, but generated private contents are ignored by Git.

Expected private outputs:

- SSH keys in `local/ssh/`.
- OpenVPN client profiles in `local/clients/`.
- local server notes in `local/server/`.
- setup logs in `local/logs/`.
- local-only backups in `local/backups/`.

## Agent Experience

The target user should be able to ask an AI agent:

```text
Use this repo to configure my OpenVPN server. Read docs/agent-playbook.md, help me fill .env, inspect my VPS, choose the correct OS/provider path, and place my client profile in local/clients/.
```

The agent must:

- keep private material in ignored folders,
- verify every destructive or access-affecting step,
- avoid broad SSH or public admin UI exposure,
- document public-safe improvements back into repo docs.

## Community Contribution Path

- Provider-specific instructions.
- Secure default OpenVPN setup.
- Agent setup guide.
- Troubleshooting and verification commands.
- Provider, OS, firewall, and OpenVPN profile contributions.

## Public Repository Controls

- Main branch changes should go through pull requests.
- Branch protection should prevent force pushes and deletion.
- Pull requests should use the repository PR template.
- Provider and OS contributions should identify tested versions and limitations.
- Security-sensitive reports should follow `SECURITY.md`.

## Public Release Checklist

- Keep `.context`, `.gitmodules`, `.codex`, and `AGENTS.override.md` out of the public branch unless explicitly approved.
- Verify no private files exist in Git history for the public branch before each release.
- Keep README language public and user-facing.
- Maintain issue templates for bug reports and provider requests.
- Add a tested release package that excludes local/private files.
