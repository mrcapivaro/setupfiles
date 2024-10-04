#!/bin/bash
set -e

# https://github.com/SpotX-Official/SpotX-Bash
echo "[*] Install SpotX in Flatpak Spotify"

DIR1=/var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify
DIR2="$HOME/.local/share/flatpak/app/com.spotify.Client/current/active/files/extra/share/spotify"

if [ -e "$DIR1" ]; then
    DIR="$DIR1"
else
    DIR="$DIR2"
fi

bash <(curl -sSL https://spotx-official.github.io/run.sh) -P "$DIR"
