#!/bin/bash
set -e
echo "[*] Setup GPU Drivers"

PACKAGES=()

if lspci | grep -qi "nvidia"; then
	PACKAGES+=("nvidia" "nvidia-libs-32bit")
else
	PACKAGES+=("mesa-dri" "mesa-dri-32bit")
fi

sudo xbps-install -y "${PACKAGES[@]}"
