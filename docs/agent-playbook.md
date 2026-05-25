# Agent Playbook

This repo is designed for an AI agent to perform the setup with the operator's approval. The scripts are helper tools, not a replacement for agent review.

## Operator Prompt

The operator can ask:

```text
Use this repo to configure my private OpenVPN server. Start by showing me what information you need, help me collect it, inspect the server, then configure the VPN only after the safety checks pass.
```

## Agent Contract

The agent must:

- keep private values in `.env` and ignored `local/` folders,
- avoid printing private keys or full `.ovpn` profiles,
- inspect the server before changing it,
- use the OS support matrix instead of assuming Ubuntu,
- confirm provider firewall expectations before relying on host firewall rules,
- verify access before SSH hardening,
- stop if the OS/provider path is unknown.

## Flow

1. Show required inputs:

```bash
scripts/setup-openvpn.sh --requirements
```

2. Collect or create `.env`:

```bash
scripts/setup-openvpn.sh --collect
```

3. Validate SSH:

```bash
scripts/setup-openvpn.sh --check
```

4. Inspect the server:

```bash
scripts/setup-openvpn.sh --inspect
```

5. Print the setup plan:

```bash
scripts/setup-openvpn.sh --plan
```

6. Execute the OS/provider-specific setup steps.

7. Pull generated private outputs into `local/`.

8. Verify and hand off the `.ovpn` profile.

## Stop Conditions

Stop and ask the operator before continuing if:

- SSH key access fails,
- the server OS is unsupported,
- another VPN/firewall is already configured,
- the provider firewall is missing or too broad,
- package installation would require third-party repositories,
- root SSH would be disabled before non-root sudo access is verified,
- any secret would need to be printed or committed.

## Output Handoff

At the end, the agent should provide:

- where the `.ovpn` file is stored,
- what was changed on the server,
- how to verify the services,
- how to revoke a client,
- what remains optional or untested.
