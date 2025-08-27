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
getAuthenticatorKey() {
	# Imprime o prompt para o terminal do usuário (stderr) para não ser capturado pela substituição de comando
	echo -n "Digite a chave do Sophos Authenticator: " >&2
	local key
	# -s faz com que a digitação não apareça na tela (mais seguro)
	read -s key
	# Imprime uma nova linha para formatação após a digitação da chave
	echo >&2
	# Imprime a chave lida para a saída padrão (stdout) para que possa ser capturada
	echo "$key"
}
open_connection() {
	loadEnv
	# Usa as variáveis carregadas do arquivo .env
	local username="$VPN_USER"
	local static_password="$VPN_KEY"
	# Constrói o caminho do arquivo de configuração dinamicamente usando o nome de usuário
	# Caminho padrão para configurações do openvpn3, seguindo a especificação XDG
	local config_dir="$HOME/.config/openvpn3"
	local config_path="${config_dir}/sslvpn-${username}-client-config.ovpn"

	echo "Tentando iniciar a sessão com a configuração: $config_path"

	# Verifica se o arquivo de configuração existe antes de tentar usá-lo
	if [ ! -f "$config_path" ]; then
		echo "Erro: Arquivo de configuração não encontrado em '$config_path'"
		echo "Por favor, certifique-se de que o arquivo .ovpn está no diretório ${config_dir}/"
		return 1 # Retorna um código de erro da função
	fi

	# Captura a chave do autenticador usando substituição de comando
	local authenticator_key
	authenticator_key=$(getAuthenticatorKey)

	# Concatena a senha estática com a chave do autenticador (padrão para 2FA)
	local final_password="${static_password}${authenticator_key}"
	# Passa a senha final para o comando via stdin usando um pipe
	printf "${username}\n${final_password}\n" | openvpn3 session-start --config "$config_path"
}

open_connection
