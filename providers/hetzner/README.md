# Hetzner Provider

Hetzner Cloud is the first tested provider for this project.

## Tested Baseline

- Location: Germany, Falkenstein.
- Server type: CX23.
- Architecture: x86 Intel/AMD.
- OS: Ubuntu 24.04 LTS.
- Networking: public IPv4 and public IPv6.
- VPN: OpenVPN Community Edition on UDP `1194`.

## Firewall

Use a Hetzner Cloud Firewall before or during setup.

Inbound allow rules:

| Description | Source | Protocol | Port |
| --- | --- | --- | --- |
| SSH admin | trusted admin IP only | TCP | 22 |
| OpenVPN | Any IPv4 and Any IPv6 | UDP | 1194 |
| ICMP diagnostics | Any IPv4 and Any IPv6 | ICMP | all |

Leave outbound rules empty for v1 so Hetzner keeps outbound traffic allowed by default.

## Labels

Recommended labels:

```text
project=vpn-vps
role=vpn
env=prod
```

## Notes For Agents

- Do not assume the server is safe to harden until SSH key access works.
- Do not add TCP `443` unless the OpenVPN TCP fallback listener is configured.
- Do not publish real server IPs or generated client profiles.
