#!/bin/bash

clear
cat <<'EOF'
########################################################
#        _           _            _ _ _                #
#       | |         | |          | (_) |               #
#   __ _| |__   __ _| | __ _ _ __| |_| |__  _ __ ___   #
#  / _` | '_ \ / _` | |/ _` | '__| | | '_ \| '__/ _ \  #
# | (_| | |_) | (_| | | (_| | |  | | | |_) | | |  __/  #
#  \__,_|_.__/ \__,_|_|\__,_|_|  |_|_|_.__/|_|  \___|  #
#                                                      #                                              
#            Copyright (C) 2025, abalarlibre           #
########################################################
EOF
sleep 2
clear

echo "Este script instalará Spotify y eliminará los anuncios."

# Comprobación de que flatpak esté instalado
if ! command -v flatpak &> /dev/null; then
    echo "Flatpak no está instalado. Instalando Flatpak..."
    sudo apt-get install flatpak -y
else
    echo "Flatpak está instalado."
fi

cd ~/

echo "Comprobando si Spotify de Flatpak está instalado..."

# Verificar si Spotify está instalado
if flatpak list | grep -q "com.spotify.Client"; then
    echo "Spotify está instalado. Continuando con la eliminación de anuncios..."
else
    echo "Spotify no está instalado. Pulsa enter para instalarlo."
    read
    echo "Se instalará Spotify. Introduce tu contraseña (usuario) para poder escribirla en las ventanas que aparecerán durante la instalación."
    sudo passwd
    echo "La contraseña se ha preparado. Ahora se instalará Spotify mediante flatpak."
    flatpak install flathub com.spotify.Client
    echo "La instalación de Spotify ha terminado."
fi

# Comprobación de que wget esté instalado
if ! command -v wget &> /dev/null; then
    echo "wget no está instalado. Instalando wget..."
    sudo apt-get install wget -y
else
    echo "wget está instalado."
fi

# Continuar con la eliminación de anuncios
echo "Se van a eliminar los anuncios. Pulsa enter para continuar."
read
echo "Eliminando anuncios... No cierres la ventana o abras Spotify."

# Descargar los archivos necesarios
wget -q https://github.com/abba23/spotify-adblock/releases/download/v1.0.3/spotify-adblock.so || { echo "Error al descargar spotify-adblock.so"; exit 1; }
wget -q https://raw.githubusercontent.com/abba23/spotify-adblock/main/config.toml || { echo "Error al descargar config.toml"; exit 1; }

mkdir -p ~/.spotify-adblock && cp ~/spotify-adblock.so ~/.spotify-adblock/spotify-adblock.so
mkdir -p ~/.var/app/com.spotify.Client/config/spotify-adblock && cp config.toml ~/.var/app/com.spotify.Client/config/spotify-adblock
flatpak override --user --filesystem="~/.spotify-adblock/spotify-adblock.so" --filesystem="~/.config/spotify-adblock/config.toml" com.spotify.Client

cd ~/
rm config.toml
rm spotify-adblock.so

echo "Anuncios eliminados. Spotify está listo para usarse."
