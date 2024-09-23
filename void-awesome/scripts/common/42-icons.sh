#!/bin/bash
set -e
echo "[*] Setup Icons"

sudo xbps-install -y gtk+ gtk+3 gtk4 papirus-icon-theme
