#!/bin/bash
# Script de instalacao manual do urlcrazy
# Modulo : Information Gathering - Business
# Aula   : Buscando domínios similares
# Treinamento Novo Pentest Profissional - NPP
# DESEC Security
# 26.12.2025
# by LMDS
# Ref: https://github.com/urbanadventurer/urlcrazy.git
#

# Verificamos se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute este script como root (sudo)."
  exit 1
fi

echo "--- Iniciando a instalação manual do UrlCrazy ---"

# Removendo o pacote do urlcrazy instalado atualmente
echo "[1/6] Removendo pacote urlcrazy antigo..."
apt purge urlcrazy -y

# Criando um script de chamada do comando em /usr/bin/urlcrazy
echo "[2/6] Criando o script executável em /usr/bin/urlcrazy..."
cat <<'EOF' > /usr/bin/urlcrazy
#!/usr/bin/env sh

set -e

cd /usr/share/urlcrazy/
exec ./urlcrazy "$@"
EOF

# Alterando as permissões do script criado
echo "[3/6] Ajustando permissões e propriedades..."
chmod 755 /usr/bin/urlcrazy
chown root:root /usr/bin/urlcrazy

# Clonando o repositório git do comando
echo "[4/6] Baixando o UrlCrazy do GitHub..."
cd /usr/share/

# Verificando se a pasta ja existe 
if [ -d "urlcrazy" ]; then
    echo "O diretório /usr/share/urlcrazy já existe. Removendo para instalação limpa..."
    rm -rf urlcrazy
fi

git clone https://github.com/urbanadventurer/urlcrazy.git

# Instalar dependências
echo "[5/6] Instalando dependências (Ruby)..."
apt update && apt install ruby ruby-dev build-essential -y

# Testando execução do comando instalado
echo "[6/6] Instalação concluída! Executando teste..."
echo "---------------------------------------------------"
urlcrazy businesscorp.com.br

