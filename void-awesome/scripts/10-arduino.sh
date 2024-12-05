#!/usr/bin/env bash
set -euo pipefail

echo "[*] Setup Arduino"

sudo xbps-install -y arduino arduino-cli
sudo usermod -a -G tty "$USER"
sudo usermod -a -G dialout "$USER"
