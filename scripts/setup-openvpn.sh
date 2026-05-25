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
  scripts/setup-openvpn.sh --inspect
  scripts/setup-openvpn.sh --plan

Commands:
  --requirements  Show the information needed before setup.
  --collect       Prompt for setup inputs and write .env.
  --check         Validate .env, SSH key path, and SSH access.
  --inspect       Inspect the remote server and write local/server/inspection.txt.
  --plan          Print the agent execution plan for the detected or configured OS.

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

8. Operating system
   Preferred: Ubuntu 24.04 LTS for the tested Hetzner path
   Other Linux distributions require an OS module and agent review

For AI agents:
- Help the user find each value.
- Do not print private keys or full .ovpn profiles.
- Write real values to .env.
- Write generated private outputs under local/.
- Run --inspect before changing the server.
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
  os_family="$(prompt_value VPN_SERVER_OS_FAMILY "Server OS family if known" "auto")"

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
VPN_SERVER_OS_FAMILY=$os_family
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

  validate_env_values
  check_ssh
}

validate_env_values() {
  : "${VPN_PROVIDER:?VPN_PROVIDER is required}"
  : "${VPN_SERVER_IPV4:?VPN_SERVER_IPV4 is required}"
  : "${VPN_SERVER_SSH_USER:?VPN_SERVER_SSH_USER is required}"
  : "${VPN_SERVER_SSH_KEY:?VPN_SERVER_SSH_KEY is required}"
  : "${VPN_CLIENT_NAME:?VPN_CLIENT_NAME is required}"
  : "${VPN_OPENVPN_PORT:?VPN_OPENVPN_PORT is required}"
  : "${VPN_OPENVPN_PROTO:?VPN_OPENVPN_PROTO is required}"

  case "$VPN_OPENVPN_PROTO" in
    udp|tcp) ;;
    *)
      echo "VPN_OPENVPN_PROTO must be udp or tcp" >&2
      exit 1
      ;;
  esac
}

ssh_key_path() {
  SSH_KEY="$VPN_SERVER_SSH_KEY"
  case "$SSH_KEY" in
    /*) ;;
    *) SSH_KEY="$ROOT_DIR/$SSH_KEY" ;;
  esac

  if [ ! -f "$SSH_KEY" ]; then
    echo "SSH key not found: $SSH_KEY" >&2
    exit 1
  fi
  printf "%s" "$SSH_KEY"
}

check_ssh() {
  SSH_KEY="$(ssh_key_path)"
  SSH_OPTS=(-o BatchMode=yes -o StrictHostKeyChecking=accept-new -i "$SSH_KEY")
  TARGET="${VPN_SERVER_SSH_USER}@${VPN_SERVER_IPV4}"

  echo "Checking SSH access to $TARGET"
  ssh "${SSH_OPTS[@]}" "$TARGET" 'id && hostname && cat /etc/os-release | sed -n "1,6p"'

  cat <<'EOF'

This script is currently a guarded agent helper. The live Hetzner server was
configured manually first, and the next project step is to promote that tested
flow into agent-led OS/provider setup modules.

For now, use docs/openvpn-runbook.md as the tested source of truth.
EOF
}

load_env() {
  if [ ! -f "$ENV_FILE" ]; then
    echo "Missing .env. Run scripts/setup-openvpn.sh --requirements, then scripts/setup-openvpn.sh --collect." >&2
    exit 1
  fi

  set -a
  # shellcheck disable=SC1090
  . "$ENV_FILE"
  set +a
  validate_env_values
}

inspect_server() {
  load_env
  SSH_KEY="$(ssh_key_path)"
  mkdir -p "$ROOT_DIR/local/server"
  output="$ROOT_DIR/local/server/inspection.txt"
  SSH_OPTS=(-o BatchMode=yes -o StrictHostKeyChecking=accept-new -i "$SSH_KEY")
  TARGET="${VPN_SERVER_SSH_USER}@${VPN_SERVER_IPV4}"

  echo "Inspecting $TARGET"
  ssh "${SSH_OPTS[@]}" "$TARGET" 'set -eu
echo "== identity =="
id
hostname
echo "== os-release =="
cat /etc/os-release
echo "== kernel =="
uname -a
echo "== network =="
ip -brief addr || true
ip route || true
echo "== listeners =="
ss -tulpen || true
echo "== services =="
systemctl is-system-running || true
' | tee "$output"
  chmod 600 "$output"
  echo "Wrote $output"
}

detected_os_family() {
  os_family="${VPN_SERVER_OS_FAMILY:-auto}"
  if [ "$os_family" != "auto" ]; then
    printf "%s" "$os_family"
    return
  fi

  inspection="$ROOT_DIR/local/server/inspection.txt"
  if [ ! -f "$inspection" ]; then
    printf "auto"
    return
  fi

  os_id="$(awk -F= '/^ID=/{gsub(/"/,"",$2); print $2; exit}' "$inspection" 2>/dev/null || true)"
  id_like="$(awk -F= '/^ID_LIKE=/{gsub(/"/,"",$2); print $2; exit}' "$inspection" 2>/dev/null || true)"

  case " $os_id $id_like " in
    *" ubuntu "*|*" debian "*) printf "debian" ;;
    *" fedora "*|*" rhel "*|*" centos "*|*" rocky "*|*" almalinux "*) printf "rhel" ;;
    *) printf "unknown" ;;
  esac
}

print_plan() {
  load_env
  family="$(detected_os_family)"

  cat <<EOF
Agent-led setup plan

Provider: $VPN_PROVIDER
Server: $VPN_SERVER_IPV4
SSH user: $VPN_SERVER_SSH_USER
Client profile: ${VPN_CLIENT_PROFILE:-local/clients/$VPN_CLIENT_NAME.ovpn}
OpenVPN: $VPN_OPENVPN_PROTO/$VPN_OPENVPN_PORT
OS family: $family

Phase 1: Intake and safety
- Confirm .env values are correct.
- Confirm provider firewall allows SSH from trusted IPs and UDP $VPN_OPENVPN_PORT.
- Run scripts/setup-openvpn.sh --inspect.
- Review local/server/inspection.txt before changing the server.

Phase 2: OS-specific package setup
EOF

  case "$family" in
    debian)
      cat <<'EOF'
- Use apt packages: openvpn, easy-rsa, nftables, fail2ban, unattended-upgrades.
- Supported tested path: Ubuntu 24.04 LTS.
EOF
      ;;
    rhel)
      cat <<'EOF'
- Use dnf packages where available.
- Confirm EPEL/OpenVPN package availability before installation.
- Treat this path as untested until a provider/OS module is added.
EOF
      ;;
    auto)
      cat <<'EOF'
- OS has not been inspected yet.
- Run scripts/setup-openvpn.sh --inspect before package decisions.
EOF
      ;;
    *)
      cat <<'EOF'
- OS family is unknown.
- Stop and add an OS module before installing packages.
EOF
      ;;
  esac

  cat <<'EOF'

Phase 3: VPN configuration
- Create or verify a non-root sudo admin before SSH hardening.
- Create Easy-RSA CA and server/client certificates.
- Configure OpenVPN Community Edition.
- Configure forwarding and host firewall/NAT.
- Store generated .ovpn profiles under local/clients/.

Phase 4: Verification
- Verify services and listeners.
- Run a server-side handshake test if OpenVPN CLI is available.
- Ask the user to test the .ovpn profile in their OpenVPN app.

Phase 5: Documentation
- Keep public docs generic.
- Store private server notes under local/server/.
- Do not commit secrets, profiles, real IP notes, or provider tokens.
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
  --inspect)
    inspect_server
    ;;
  --plan)
    print_plan
    ;;
  -h|--help)
    usage
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac
