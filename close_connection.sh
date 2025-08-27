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
##
# Close an OpenVPN3 session for a given username
#
# @param string $1 Username (e.g., douglassilva)
#
close_connection() {
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

  if [[ -z "$paths" ]]; then
    echo "No active sessions found for user: $username"
    exit 1
  fi

  # Iterate over all found paths and close them
  for path in $paths; do
    echo "Closing session: $path"
    openvpn3 session-manage --session-path "$path" --disconnect
  done
}

# Run function passing script argument
close_connection "$1"
