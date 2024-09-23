#!/bin/bash
set -e
echo "[*] Setup Display Manager"

sudo xbps-install lightdm lightdm-gtk-greeter
sudo ln -sf /etc/sv/lightdm /var/service
