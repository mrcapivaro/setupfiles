#!/bin/bash
set -e
echo "[*] Setup GPU Drivers"

if lspci | grep -qi "nvidia"; then
	sudo xbps-install -y nvidia nvidia-libs-32bit
fi
