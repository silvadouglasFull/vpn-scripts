#!bin/bash

install_deps() {
	echo "Verificando e instalando dependências..."

	# Verifica se o sistema é baseado em Debian/Ubuntu
	if command -v apt &>/dev/null; then
		echo "Sistema baseado em Debian/Ubuntu detectado."
		sudo apt update
		sudo apt install -y openvpn3

		# Verifica se a instalação foi bem-sucedida
		if dpkg -s openvpn3 &>/dev/null; then
			echo "OpenVPN3 instalado com sucesso."
		else
			echo "Erro: Falha na instalação do OpenVPN3."
			exit 1
		fi
	# Verifica se o sistema é baseado em Fedora/RHEL
	elif command -v dnf &>/dev/null; then
		echo "Sistema baseado em Fedora/RHEL detectado."
		sudo dnf install -y openvpn3

		# Verifica se a instalação foi bem-sucedida
		if rpm -q openvpn3 &>/dev/null; then
			echo "OpenVPN3 instalado com sucesso."
		else
			echo "Erro: Falha na instalação do OpenVPN3."
			exit 1
		fi
	# Adicione suporte para outros gerenciadores de pacote aqui
	else
		echo "Gerenciador de pacotes não suportado. Por favor, instale o OpenVPN3 manualmente."
		exit 1
	fi

	echo "Dependências verificadas/instaladas com sucesso."
}

# Chama a função para instalar as dependências
install_deps