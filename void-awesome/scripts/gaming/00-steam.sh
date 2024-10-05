#!/bin/bash
set -e
echo "[*] Setup Steam"

sudo xbps-install -y \
	steam \
	libgcc-32bit \
	libstdc++-32bit \
	libdrm-32bit \
	libglvnd-32bit
