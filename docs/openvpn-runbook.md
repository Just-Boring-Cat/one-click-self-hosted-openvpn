# OpenVPN Runbook

## Current Server State

The VPS is configured as an OpenVPN Community Edition server on Ubuntu 24.04 LTS.

Installed services:
- `openvpn-server@server`
- `nftables`
- `fail2ban`
- `unattended-upgrades`
- `ssh`

Administrative access:
- SSH user: `vpnadmin`
- Root SSH login: disabled
- Password SSH login: disabled
- SSH key: project key under `artifacts/private/ssh/`

OpenVPN listener:
- Protocol: UDP
- Port: `1194`
- Device: `tun0`
- IPv4 VPN subnet: `10.8.0.0/24`
- IPv6 VPN subnet: `fd42:42:42:42::/64`

Client traffic:
- IPv4 client traffic is routed through the VPN server and masqueraded out through `eth0`.
- IPv6 client traffic is routed through the VPN server and masqueraded out through `eth0`.
- DNS pushed to clients: `1.1.1.1` and `9.9.9.9`.

## Server Files

Server configuration:

```text
/etc/openvpn/server/server.conf
```

Server certificate material:

```text
/etc/openvpn/server/
```

Certificate authority workspace:

```text
/root/openvpn-ca/
```

The CA workspace contains private signing material. Do not publish it, copy it into tracked repo files, or include it in public setup examples.

## Local Private Files

The first client profile is stored locally at:

```text
local/clients/<client-name>.ovpn
```

This file contains private client key material and must stay ignored by Git.

## Verification Commands

Run these from the local project directory:

```bash
ssh -i local/ssh/id_ed25519 vpnadmin@<server-ip> 'systemctl is-active openvpn-server@server nftables fail2ban unattended-upgrades ssh'
```

```bash
ssh -i local/ssh/id_ed25519 vpnadmin@<server-ip> 'sudo ss -tulpen'
```

```bash
ssh -i local/ssh/id_ed25519 vpnadmin@<server-ip> 'ip -brief addr show tun0 && sudo nft list ruleset'
```

Expected result:
- OpenVPN service is active.
- `tun0` exists.
- UDP `1194` is listening.
- SSH is listening, but Hetzner Firewall should restrict who can reach it.
- No public web/admin UI is listening.

## Completed Server-Side Validation

The first generated client profile completed a controlled server-side handshake test with route changes disabled. The test reached `Initialization Sequence Completed`, received IPv4 `10.8.0.2`, received IPv6 `fd42:42:42:42::1000`, and negotiated `AES-256-GCM`.

This proves the generated profile, CA, server certificate, client certificate, `tls-crypt` key, and UDP listener match. A real device/client app test is still required to verify end-user routing and DNS behavior.

## Client Test

Import this profile into the OpenVPN client app:

```text
local/clients/<client-name>.ovpn
```

After connecting, verify:
- Public IPv4 changes to the VPS egress IP.
- DNS resolution works.
- Normal websites load.
- SSH to the server still works through the trusted admin path.

## Create Another Client

Use a unique client name per device or person.

```bash
CLIENT_NAME='<client-name>'
ssh -i local/ssh/id_ed25519 vpnadmin@<server-ip>
sudo -i
cd /root/openvpn-ca
EASYRSA_BATCH=1 EASYRSA_REQ_CN="$CLIENT_NAME" ./easyrsa gen-req "$CLIENT_NAME" nopass
EASYRSA_BATCH=1 ./easyrsa sign-req client "$CLIENT_NAME"
```

Then build an inline `.ovpn` profile using the same structure as the first generated profile.

## Revoke A Client

```bash
CLIENT_NAME='<client-name>'
ssh -i local/ssh/id_ed25519 vpnadmin@<server-ip>
sudo -i
cd /root/openvpn-ca
EASYRSA_BATCH=1 ./easyrsa revoke "$CLIENT_NAME"
./easyrsa gen-crl
install -m 644 pki/crl.pem /etc/openvpn/server/crl.pem
systemctl restart openvpn-server@server
```

## Public Release Notes

For future open-source packaging:
- Replace real server IPs with placeholders.
- Do not ship generated certificates, keys, client profiles, CA material, logs, or local SSH keys.
- Convert the setup into a parameterized script with explicit inputs.
- Keep the secure defaults: key-only SSH, root SSH disabled, no public admin UI, UDP `1194` only, outbound unrestricted unless a full policy exists.
