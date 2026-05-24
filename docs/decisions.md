# Decisions

## 2026-05-24: Use Hetzner Cloud Germany

Decision: Host the private VPN on Hetzner Cloud in Germany.

Rationale: Hetzner offers low-cost German VPS hosting with enough included traffic for a personal VPN.

Alternatives: Other VPS providers or a self-hosted home server.

## 2026-05-24: Use CX23 For Initial Server

Decision: Start with a CX23 x86 server.

Rationale: 2 vCPU, 4 GB RAM, and 40 GB disk are sufficient for the initial private OpenVPN setup.

Alternatives: Smaller server if available, larger shared server for more clients, or dedicated vCPU if sustained CPU load becomes a problem.

## 2026-05-24: Use Ubuntu 24.04 LTS

Decision: Use Ubuntu 24.04 LTS for the first production setup.

Rationale: It is a stable LTS baseline with broad OpenVPN package support.

Alternatives: Ubuntu 26.04 LTS later, after the project validates package support and operational behavior.

## 2026-05-24: Use OpenVPN Community Edition

Decision: Use OpenVPN Community Edition and configure it manually.

Rationale: Avoid paid Access Server connection limits, keep full control, and avoid exposing a web administration interface.

Alternatives: OpenVPN Access Server for easier UI-based administration, or WireGuard for a leaner VPN protocol.

## 2026-05-24: Minimize Public Exposure

Decision: Expose only SSH and OpenVPN by default.

Rationale: The server should have the smallest practical attack surface.

Alternatives: Public admin UI or broader SSH access, both rejected for v1.
