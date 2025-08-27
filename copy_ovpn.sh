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
copy_ovpn() {
	local config_dir="$HOME/.config/openvpn3"

	# Cria o diretório de configuração se ele não existir
	if [ ! -d "$config_dir" ]; then
		mkdir -p "$config_dir"
		if [ $? -ne 0 ]; then
			echo "Erro: Não foi possível criar o diretório '$config_dir'."
			return 1
		fi
		echo "Diretório '$config_dir' criado."
	fi

	read -p "Por favor, digite o caminho completo do arquivo .ovpn: " ovpn_path

	# Remove aspas simples ou duplas do caminho, se houver
	ovpn_path=$(echo "$ovpn_path" | sed -e "s/^'//" -e "s/'$//" -e "s/^\"//" -e "s/\"$//")

	# Verifica se o arquivo existe
	if [ ! -f "$ovpn_path" ]; then
		echo "Erro: O arquivo '$ovpn_path' não foi encontrado."
		return 1 # Retorna um código de erro
	fi

	# Obtém apenas o nome do arquivo do caminho completo
	filename=$(basename "$ovpn_path")

	# Copia o arquivo para o diretório de configuração
	cp "$ovpn_path" "$config_dir/$filename"

	if [ $? -eq 0 ]; then
		echo "Arquivo '$filename' copiado com sucesso para '$config_dir/'."
	else
		echo "Erro: Não foi possível copiar o arquivo '$filename'."
		return 1
	fi
}

# Chama a função para iniciar o processo de cópia
copy_ovpn
