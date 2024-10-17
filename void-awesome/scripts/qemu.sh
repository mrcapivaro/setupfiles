#!/bin/bash
set -e
echo "[*] Setup Qemu"

PACKAGES=(
    "qemu"
    "coreutils"
    "qemu-firmware"
    "pciutils"
    "procps-ng"
    "cdrtools"
    "usbutils"
    "util-linux"
    "socat"
    "spicy"
    "swtpm"
    "zsync"
)

sudo xbps-install -y "${PACKAGES[@]}"

# Quickemu: https://github.com/quickemu-project/quickemu/wiki/01-Installation
INSTALL_DIR="$HOME/Code/quickemu"
sudo mkdir -p "$INSTALL_DIR"
git clone --filter=blob:none https://github.com/quickemu-project/quickemu \
    "$INSTALL_DIR"
