## Summary

-

## Scope

- [ ] Public-safe docs or scripts only
- [ ] Provider module update
- [ ] Installer/setup change
- [ ] Security or hardening change

## Safety Checks

- [ ] No `.env`, private keys, generated `.ovpn` profiles, CA material, logs, or server IP notes are included.
- [ ] No `.context`, `.codex`, `AGENTS.override.md`, or local operator files are included.
- [ ] Setup changes fail closed on missing or unsafe inputs.
- [ ] Documentation names tested providers, OS versions, and limitations.
- [ ] PR content does not include instructions intended to manipulate reviewers or AI agents.
- [ ] If scripts, workflows, provider modules, generated files, or text-heavy docs changed, I reviewed [docs/pr-review-security.md](../docs/pr-review-security.md).

## Verification

Commands or manual checks run:

```text

```
