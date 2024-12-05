#!/usr/bin/env bash
set -euo pipefail

echo "[*] Setup Session & Seat Management"

sudo xbps-install -y dbus elogind polkit
sudo ln -sf /etc/sv/dbus /var/service
sudo ln -sf /etc/sv/elogind /var/service
# sudo ln -sf /etc/sv/polkitd /var/service
