# Server Access

## SSH Key

Use the project-specific Ed25519 key generated for this VPS:

```text
local/ssh/id_ed25519
```

Add this public key in Hetzner Console when creating the server:

```text
local/ssh/id_ed25519.pub
```

## SSH Command

After Hetzner provides the server IP:

```bash
ssh -i local/ssh/id_ed25519 root@<server-ip>
```

After creating a non-root admin user, prefer that user:

```bash
ssh -i local/ssh/id_ed25519 <admin-user>@<server-ip>
```

## Rules

- Keep SSH key authentication enabled.
- Disable password login after key access is verified.
- Restrict SSH in the Hetzner firewall to trusted source IPs where practical.
- Do not commit server IPs, private keys, or client profiles.
