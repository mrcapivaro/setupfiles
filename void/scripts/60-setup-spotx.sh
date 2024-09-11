#!/bin/bash
set -e

# src: https://github.com/Nuzair46/SpotX-Linux
bash <(curl -sSL https://raw.githubusercontent.com/SpotX-CLI/SpotX-Linux/main/install.sh) -P /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/
