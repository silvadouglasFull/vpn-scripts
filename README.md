# Scripts de Conexão VPN com OpenVPN3

Este projeto contém uma coleção de scripts de shell para facilitar a conexão a uma VPN usando OpenVPN3.

## Pré-requisitos

Antes de usar os scripts, você precisa ter o OpenVPN3 instalado em seu sistema. O script `install_deps.sh` pode ser usado para instalar a dependência em sistemas baseados em Debian/Ubuntu ou Fedora/RHEL.

Para instalar as dependências, execute o seguinte comando:

```bash
./install_deps.sh
```

## Configuração

1.  **Arquivo .env**:
    Renomeie o arquivo `.env.example` para `.env` e preencha as seguintes variáveis:

    - `VPN_USER`: Seu nome de usuário da VPN.
    - `VPN_KEY`: Sua senha estática da VPN.
    - `VPN_OWNER`: O dono do processo da vpn, geralmente o mesmo que `VPN_USER`.

2.  **Arquivo de Configuração .ovpn**:
    Execute o script `copy_ovpn.sh` para copiar seu arquivo de configuração `.ovpn` para o diretório de configuração do OpenVPN3.

    ```bash
    ./copy_ovpn.sh
    ```

    O script solicitará o caminho completo para o seu arquivo `.ovpn`.

## Como Usar

Depois de concluir a configuração, você pode usar os seguintes scripts para gerenciar sua conexão VPN:

- **`open_connection.sh`**: Inicia a conexão VPN. O script solicitará sua chave do Sophos Authenticator.

  ```bash
  ./open_connection.sh
  ```

- **`close_connection.sh`**: Fecha a conexão VPN.

  ```bash
  ./close_connection.sh
  ```

- **`list_sessions.sh`**: Lista as sessões VPN ativas.

  ```bash
  ./list_sessions.sh
  ```

## Scripts

Aqui está uma breve descrição de cada script:

- **`install_deps.sh`**: Instala o `openvpn3` em sistemas baseados em Debian/Ubuntu ou Fedora/RHEL.
- **`copy_ovpn.sh`**: Copia o arquivo de configuração `.ovpn` para o diretório de configuração do OpenVPN3 (`~/.config/openvpn3/`).
- **`open_connection.sh`**: Inicia a conexão VPN usando o arquivo de configuração `.ovpn` e as credenciais do arquivo `.env`.
- **`close_connection.sh`**: Fecha a conexão VPN para o usuário especificado no arquivo `.env`.
- **`list_sessions.sh`**: Lista as sessões VPN ativas para o usuário especificado no arquivo `.env`.
