# Provider Template

Copy this folder when adding another provider.

## Provider

- Name:
- Website:
- Supported regions:
- Tested regions:

## Recommended Server

- CPU:
- RAM:
- Disk:
- Architecture:
- OS:

## Networking

- Public IPv4 required:
- Public IPv6 supported:
- Private network required:
- Floating/static IP notes:

## Firewall Or Security Group

Inbound allow rules:

| Description | Source | Protocol | Port |
| --- | --- | --- | --- |
| SSH admin | trusted admin IP only | TCP | 22 |
| OpenVPN | any required client networks | UDP | 1194 |
| ICMP diagnostics | provider-supported diagnostic scope | ICMP | all |

Outbound rules:
- Default recommendation:
- Provider caveats:

## Agent Notes

- Provider CLI/API:
- Required permissions:
- Common failure modes:
- Cleanup/destroy notes:
