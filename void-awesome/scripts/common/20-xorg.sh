#!/usr/bin/env bash
set -euo pipefail

echo "[*] Setup Xorg"

sudo xbps-install -y xorg xclip
