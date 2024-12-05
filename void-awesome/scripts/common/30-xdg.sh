#!/usr/bin/env bash
set -euo pipefail

echo "[*] Setup XDG"

packages=(
    "xdg-desktop-portal"
    "xdg-desktop-portal-gtk"
    "xdg-user-dirs"
    "dex"
)

sudo xbps-install -y "${packages[@]}"
