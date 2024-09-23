#!/bin/bash
set -e

# https://github.com/SpotX-Official/SpotX-Bash
bash <(curl -sSL https://spotx-official.github.io/run.sh) -P /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/
