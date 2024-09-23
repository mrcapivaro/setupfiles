#!/bin/bash
set -e
echo "[*] Setup Display Manager"

sudo xbps-install -y lightdm lightdm-gtk-greeter
sudo ln -sf /etc/sv/lightdm /var/service
