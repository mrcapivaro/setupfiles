#!/usr/bin/env bash
set -euo pipefail

echo "[*] Setup Display Manager"

sudo xbps-install -y lightdm lightdm-gtk-greeter
sudo ln -sf /etc/sv/lightdm /var/service
