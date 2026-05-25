# OS Support

This project should not assume every VPS runs Ubuntu. The first tested path is Ubuntu 24.04 LTS, but the public repo should grow through explicit OS modules.

## Support Levels

| Level | Meaning |
| --- | --- |
| Tested | Installed and verified end to end on a real server. |
| Documented | Package and service differences are documented, but not end-to-end tested. |
| Planned | Intended support, no implementation yet. |
| Unsupported | Agent must stop and request an OS module before changing the server. |

## Current Matrix

| OS family | Example distributions | Status | Notes |
| --- | --- | --- | --- |
| Debian family | Ubuntu 24.04 LTS, Debian 12 | Tested for Ubuntu 24.04 LTS | Uses `apt`, `systemd`, `openvpn-server@server`, Easy-RSA from packages, `nftables`. |
| RHEL family | Rocky, AlmaLinux, Fedora | Planned | Requires package availability checks and service-path validation. |
| Alpine | Alpine Linux | Planned | Different package names and service management. |
| Arch family | Arch Linux | Unsupported for now | Add a module before use. |
| FreeBSD/OpenBSD | BSD systems | Unsupported for now | Not Linux; requires a separate design. |

## Agent Rules

- Run `scripts/setup-openvpn.sh --inspect` before package installation.
- Read `/etc/os-release` and service layout before assuming commands.
- If the OS family is unknown, stop and ask for permission to add an OS module.
- Do not silently translate commands across distributions.
- Keep OS-specific commands in docs or scripts that clearly name the OS family.

## Debian Family Baseline

Packages:

```bash
apt-get update
apt-get install -y openvpn easy-rsa nftables fail2ban unattended-upgrades
```

Expected OpenVPN service layout:

```text
/etc/openvpn/server/server.conf
openvpn-server@server
```

## RHEL Family Placeholder

Before implementation, verify:

- whether OpenVPN is available from base repos or EPEL,
- Easy-RSA package name and path,
- OpenVPN systemd service name,
- firewall service interaction with `nftables` or `firewalld`,
- SELinux implications.

Until verified, RHEL-family setup is not a one-shot path.
