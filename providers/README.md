# Providers

Provider modules document the cloud-provider-specific setup needed before the common OpenVPN script runs.

## Current Providers

- [hetzner](hetzner/README.md) - tested first provider.
- [_template](_template/README.md) - copy this when adding a new provider.

## Provider Module Requirements

Each provider folder should document:

- Supported regions.
- Recommended server size.
- Supported operating systems.
- Networking requirements.
- Firewall/security group rules.
- SSH key setup.
- Provider-specific labels/tags.
- Known caveats.

The common OpenVPN configuration should stay provider-neutral whenever possible.
