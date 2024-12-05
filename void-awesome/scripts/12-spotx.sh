#!/usr/bin/env bash
set -euo pipefail

# https://github.com/SpotX-Official/SpotX-Bash
echo "[*] Install SpotX in Flatpak Spotify"

# possible spotify paths in a flatpak spotify case
spot_dir1=/var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify
spot_dir2="$HOME/.local/share/flatpak/app/com.spotify.Client/current/active/files/extra/share/spotify"

[ -e "$spot_dir1" ] && true_spot_dir="$spot_dir1" || true_spot_dir="$spot_dir2"
bash <(curl -sSLf https://spotx-official.github.io/run.sh) -P "$true_spot_dir"
