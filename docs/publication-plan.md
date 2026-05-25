# Publication Plan

## Public Project Goal

Publish a public, agent-friendly OpenVPN setup repository that helps operators configure their own private VPS-hosted VPN with secure defaults and clear provider modules.

The public project should be useful for self-service users while supporting paid help for custom setup, provider migration, hardening review, and maintenance.

## Public Folder Structure

```text
.
├── .env.example
├── README.md
├── SECURITY.md
├── docs/
│   ├── agent-setup.md
│   ├── firewall.md
│   ├── openvpn-runbook.md
│   └── publication-plan.md
├── local/
│   ├── ssh/
│   ├── clients/
│   ├── server/
│   ├── logs/
│   └── backups/
├── providers/
│   ├── hetzner/
│   └── _template/
└── scripts/
    └── setup-openvpn.sh
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

## Monetization Path

Free public repo:
- Provider-specific instructions.
- Secure default OpenVPN setup.
- Agent setup guide.
- Troubleshooting and verification commands.

Paid services:
- Configure the VPN on a customer's VPS.
- Add another provider module.
- Review and harden an existing setup.
- Create client profiles and revocation workflow.
- Provide maintenance and patching support.

The website funnel, intake forms, pricing pages, and service landing pages will live in a separate website project, not this repository.

## Before Publishing

- Keep `.context`, `.gitmodules`, `.codex`, and `AGENTS.override.md` out of the public branch unless explicitly approved.
- Verify no private files exist in Git history for the public branch.
- Replace private-project README language with public user-facing copy.
- Add issue templates for bug reports, provider requests, and paid support inquiries.
- Add a tested release package that excludes local/private files.
