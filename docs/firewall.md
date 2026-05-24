# Hetzner Firewall Runbook

## Goal

Use a Hetzner Cloud Firewall as the first perimeter allow-list for the VPN server.

Default posture:
- Drop all inbound traffic except the rules listed below.
- Leave outbound traffic unrestricted during setup and package updates.
- Do not expose a public admin UI.

## Recommended Firewall

Name:

```text
vpn-vps-prod
```

Labels:

```text
project=vpn-vps
role=vpn
env=prod
```

## Inbound Rules

Create these inbound allow rules:

| Description | Source | Protocol | Port |
| --- | --- | --- | --- |
| SSH admin | `<trusted-ipv4>/32` and optionally `<trusted-ipv6>/128` | TCP | 22 |
| OpenVPN | Any IPv4 and Any IPv6 | UDP | 1194 |
| ICMP diagnostics | Any IPv4 and Any IPv6 | ICMP | all |

Do not use `Any IPv4` or `Any IPv6` for SSH unless it is a temporary break-glass rule. If SSH must be opened broadly for a short setup window, remove the broad SSH rule as soon as key-based access and the trusted source IP rule are verified.

## Outbound Rules

Leave outbound rules empty for v1.

Hetzner allows all outbound traffic when no outbound rule is specified. Adding any outbound allow rule changes outbound behavior to allow-list mode, which can break package updates, DNS, NTP, OpenVPN routing, and troubleshooting until a full outbound policy is designed.

## Apply To

Preferred for one server:
- Select the specific VPN server in `Apply to`.

Preferred if the project later has multiple VPN servers:
- Apply by label selector, for example `role=vpn`.
- Verify the preview includes only intended servers before creating or saving the firewall.

## Setup Order

1. Create or edit inbound rules.
2. Leave outbound rules empty.
3. Apply the firewall to the VPN server.
4. Add labels.
5. Name the firewall `vpn-vps-prod`.
6. Create the firewall.
7. Verify SSH still works from the trusted source IP.
8. Verify blocked SSH from untrusted networks if practical.
9. After OpenVPN is installed, verify UDP 1194 connectivity from a client.

## Future Optional Rule

Only add this if UDP 1194 is blocked on networks that need to use the VPN:

| Description | Source | Protocol | Port |
| --- | --- | --- | --- |
| OpenVPN TCP fallback | Any IPv4 and Any IPv6 | TCP | 443 |

This requires configuring a separate OpenVPN TCP listener. Do not add TCP 443 until that listener exists.
