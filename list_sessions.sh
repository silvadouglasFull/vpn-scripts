#!/bin/bash
loadEnv() {
	local env_file
	# Encontra o diretório do script para localizar o .env de forma confiável
	local script_dir
	script_dir=$(dirname -- "$(readlink -f -- "$0")")
	env_file="$script_dir/.env"

	if [[ ! -f "$env_file" ]]; then
		echo "Erro: Arquivo de configuração .env não encontrado em '$script_dir/'"
		exit 1
	fi
	# shellcheck source=/dev/null
	source "$env_file"
}

list_sessions() {
  loadEnv
  local username="$VPN_OWNER"
  # Check if username was provided
  if [[ -z "$username" ]]; then
    echo "Usage: $0 <username>"
    exit 1
  fi

  # Extract paths from sessions belonging to the given user
  local paths
  paths=$(openvpn3 sessions-list | awk -v user="$username" '
    /^ *Path:/ { path=$2 }
    /^ *Owner:/ { if ($2 == user) print path }
  ')
  local sessions_info
  sessions_info=$(openvpn3 sessions-list | awk -v user="$username" '
    /^ *Path:/ { current_path=$2 }
    /^ *Owner:/ { if ($2 == user) { owner=$2 } }
    /^ *Created:/ { created=$2 " " $3 " " $4 }
    /^ *Connected to:/ { connected_to=$3 }
    /^ *Status:/ { status=$2; if (owner == user) { print "Path: " current_path "\n Owner: " owner "\n Created: " created "\n Connected to: " connected_to "\n Status: " status } }
  ')

  if [[ -z "$sessions_info" ]]; then
    echo "No active sessions found for user: $username"
    exit 1
  fi

  echo "Active sessions for user: $username"
  echo "-----------------------------------"
  echo "$sessions_info"
  echo "-----------------------------------"
  return 0

  if [[ -z "$paths" ]]; then
    echo "No active sessions found for user: $username"
    exit 1
  fi

  # Iterate over all found paths and close them
  for path in $paths; do
    echo "See session: $path"
  done
}
list_sessions