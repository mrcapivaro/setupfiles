#!/usr/bin/env bash
set -euo pipefail

echo "[*] Setup GPU Drivers"

packages=()

if lspci | grep -qi "nvidia"; then
    packages+=("nvidia" "nvidia-libs-32bit")
else
    packages+=("mesa-dri" "mesa-dri-32bit")
fi

sudo xbps-install -y "${packages[@]}"
