#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"
COMMAND="${1:---check}"

usage() {
  cat <<'EOF'
Usage:
  scripts/setup-openvpn.sh --requirements
  scripts/setup-openvpn.sh --collect
  scripts/setup-openvpn.sh --check

Commands:
  --requirements  Show the information needed before setup.
  --collect       Prompt for setup inputs and write .env.
  --check         Validate .env, SSH key path, and SSH access.

Real secrets and generated outputs stay in ignored local files.
EOF
}

print_requirements() {
  cat <<'EOF'
Information needed before setup:

1. VPS provider
   Example: hetzner

2. Server public IPv4 or hostname
   Example: 203.0.113.10

3. SSH admin user
   Example: root for first login, or vpnadmin after hardening

4. SSH private key path
   Example: local/ssh/id_ed25519

5. First OpenVPN client profile name
   Example: primary-laptop

6. Provider firewall status
   Confirm SSH is reachable from your trusted IP and UDP 1194 is allowed.

7. OpenVPN listener
   Default: udp/1194

For AI agents:
- Help the user find each value.
- Do not print private keys or full .ovpn profiles.
- Write real values to .env.
- Write generated private outputs under local/.
EOF
}

prompt_value() {
  var_name="$1"
  prompt="$2"
  default="${3:-}"
  if [ -n "$default" ]; then
    printf "%s [%s]: " "$prompt" "$default" >&2
  else
    printf "%s: " "$prompt" >&2
  fi
  IFS= read -r value
  if [ -z "$value" ]; then
    value="$default"
  fi
  if [ -z "$value" ]; then
    echo "Missing required value for $var_name" >&2
    exit 1
  fi
  printf "%s" "$value"
}

collect_env() {
  if [ -f "$ENV_FILE" ]; then
    echo ".env already exists at $ENV_FILE" >&2
    echo "Move it aside before collecting new values." >&2
    exit 1
  fi

  mkdir -p "$ROOT_DIR/local/ssh" "$ROOT_DIR/local/clients" "$ROOT_DIR/local/server" "$ROOT_DIR/local/logs" "$ROOT_DIR/local/backups"

  provider="$(prompt_value VPN_PROVIDER "VPS provider" "hetzner")"
  server_ipv4="$(prompt_value VPN_SERVER_IPV4 "Server public IPv4 or hostname")"
  ssh_user="$(prompt_value VPN_SERVER_SSH_USER "SSH user" "root")"
  ssh_key="$(prompt_value VPN_SERVER_SSH_KEY "SSH private key path" "local/ssh/id_ed25519")"
  client_name="$(prompt_value VPN_CLIENT_NAME "First client profile name" "primary")"
  firewall_ready="$(prompt_value VPN_PROVIDER_FIREWALL_READY "Provider firewall ready? yes/no" "no")"
  openvpn_port="$(prompt_value VPN_OPENVPN_PORT "OpenVPN UDP port" "1194")"
  openvpn_proto="$(prompt_value VPN_OPENVPN_PROTO "OpenVPN protocol" "udp")"

  cat > "$ENV_FILE" <<EOF
# Private local environment for this VPN server.
# Do not commit this file.

VPN_PROVIDER=$provider
VPN_SERVER_IPV4=$server_ipv4
VPN_SERVER_SSH_USER=$ssh_user
VPN_SERVER_SSH_KEY=$ssh_key
VPN_SERVER_SSH_COMMAND="ssh -i $ssh_key $ssh_user@$server_ipv4"
VPN_CLIENT_NAME=$client_name
VPN_CLIENT_PROFILE=local/clients/$client_name.ovpn
VPN_PROVIDER_FIREWALL_READY=$firewall_ready
VPN_OPENVPN_PORT=$openvpn_port
VPN_OPENVPN_PROTO=$openvpn_proto
EOF

  chmod 600 "$ENV_FILE"
  echo "Wrote $ENV_FILE"
  echo "Next: place the SSH private key at $ssh_key, then run scripts/setup-openvpn.sh --check"
}

check_env() {
  if [ ! -f "$ENV_FILE" ]; then
    echo "Missing .env. Run scripts/setup-openvpn.sh --requirements, then scripts/setup-openvpn.sh --collect." >&2
    exit 1
  fi

  set -a
  # shellcheck disable=SC1090
  . "$ENV_FILE"
  set +a

  : "${VPN_PROVIDER:?VPN_PROVIDER is required}"
  : "${VPN_SERVER_IPV4:?VPN_SERVER_IPV4 is required}"
  : "${VPN_SERVER_SSH_USER:?VPN_SERVER_SSH_USER is required}"
  : "${VPN_SERVER_SSH_KEY:?VPN_SERVER_SSH_KEY is required}"
  : "${VPN_CLIENT_NAME:?VPN_CLIENT_NAME is required}"
  : "${VPN_OPENVPN_PORT:?VPN_OPENVPN_PORT is required}"
  : "${VPN_OPENVPN_PROTO:?VPN_OPENVPN_PROTO is required}"

  SSH_KEY="$VPN_SERVER_SSH_KEY"
  case "$SSH_KEY" in
    /*) ;;
    *) SSH_KEY="$ROOT_DIR/$SSH_KEY" ;;
  esac

  if [ ! -f "$SSH_KEY" ]; then
    echo "SSH key not found: $SSH_KEY" >&2
    exit 1
  fi

  SSH_OPTS=(-o BatchMode=yes -o StrictHostKeyChecking=accept-new -i "$SSH_KEY")
  TARGET="${VPN_SERVER_SSH_USER}@${VPN_SERVER_IPV4}"

  echo "Checking SSH access to $TARGET"
  ssh "${SSH_OPTS[@]}" "$TARGET" 'id && hostname && cat /etc/os-release | sed -n "1,6p"'

  cat <<'EOF'

This script is currently a guarded setup entrypoint. The live Hetzner server was
configured manually first, and the next project step is to promote that tested
flow into an idempotent public installer.

For now, use docs/openvpn-runbook.md as the tested source of truth.
EOF
}

case "$COMMAND" in
  --requirements)
    print_requirements
    ;;
  --collect)
    collect_env
    ;;
  --check)
    check_env
    ;;
  -h|--help)
    usage
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac
