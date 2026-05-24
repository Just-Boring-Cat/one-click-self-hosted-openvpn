# Detection And Stealth Options

## What Websites Can See

Websites generally do not see "OpenVPN" directly. They see the VPN server's public egress IP and browser/client signals.

Likely signals:
- The egress IP belongs to a datacenter or VPS provider ASN.
- The IP range may have a provider reputation.
- Login location changes may look unusual.
- Browser fingerprinting can still identify the same browser/device.
- DNS, WebRTC, or app leaks can reveal non-VPN network details if the client is misconfigured.

This private VPS should reduce shared-exit-node problems because only the operator uses the IP. It does not make the IP look residential.

## What Networks Can See

The local network, ISP, or censor sees a connection to the VPS. They may try to classify the protocol using port, packet timing, packet size, and protocol fingerprints.

The current setup already uses:

- `tls-crypt`, which encrypts and authenticates OpenVPN control-channel packets.
- UDP `1194`, the standard OpenVPN port.
- No public admin UI.

`tls-crypt` makes OpenVPN harder to identify than plain TLS-control OpenVPN, but it is not a full stealth/obfuscation layer.

## Options

| Option | Helps With | Performance Impact | Complexity | Recommendation |
| --- | --- | --- | --- | --- |
| Keep current UDP `1194` + `tls-crypt` | Baseline privacy and good performance | Minimal | Low | Current default |
| Add UDP `443` profile | Simple port-based blocking and networks that allow QUIC/UDP 443 | Minimal to low | Low | Good next option |
| Add TCP `443` fallback | Networks that block UDP | Medium to high for normal web traffic through the tunnel | Medium | Optional fallback only |
| Upgrade to `tls-crypt-v2` | Per-client control-channel keys and better client isolation | Minimal | Medium | Worth considering after v1 |
| Wrap OpenVPN in stunnel/obfs-style transport | Deep packet inspection and stricter censorship | Medium to high | High | Advanced optional module |
| Use residential/home exit instead of VPS | Website IP-reputation detection | Depends on home upload speed/latency | High operational tradeoff | Separate product path |

## Recommended Path For This Project

1. Keep current UDP `1194` as the default fast profile.
2. Add an optional UDP `443` OpenVPN profile/listener.
3. Add a TCP `443` fallback only for users on restrictive networks.
4. Treat stunnel/obfs-style transports as a future advanced module.
5. Do not promise that VPS VPN traffic will look residential.

## Performance Notes

UDP `1194` and UDP `443` should perform similarly when the network allows them.

TCP `443` can be much slower for normal browsing and downloads through the VPN because most web traffic is already TCP inside the tunnel. Running TCP inside a TCP VPN transport can cause stacked retransmission and head-of-line blocking under packet loss.

Obfuscation layers add CPU, latency, setup complexity, and client support requirements. They are useful for restrictive networks, not as the default for users who only need a private VPN.

## Website Detection Notes

Changing from UDP `1194` to UDP/TCP `443` does not change the public egress IP. Websites will still see the Hetzner VPS IP. If a site flags datacenter IPs, transport obfuscation does not solve that.

To reduce website friction:

- Keep the VPN private and avoid sharing the IP.
- Avoid automated scraping or high-volume requests.
- Use normal browser settings and avoid unusual fingerprint combinations.
- Check for DNS/WebRTC leaks from the client device.
- Consider a home/residential exit only if website IP reputation matters more than VPS reliability.
