#!/usr/bin/env bash
set -euo pipefail
echo "[*] Setup Lutris"

packages=(
    "lutris"
    "wine"
    "wine-32bit"
    "mono"
    "wine-mono"
    "protontricks"
    "winetrics"
    "winegui"
    "mesa"
    "mesa-32bit"
    "vulkan-loader"
    "vulkan-loader-32bit"
    "MangoHud"
)

sudo xbps-install -y ${packages[@]}
