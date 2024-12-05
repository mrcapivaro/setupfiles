#!/usr/bin/env bash
set -euo pipefail

echo "[*] Setup Network"
sudo xbps-install -y connman connman-ncurses cmst iwd runnit-iptables
sudo unlink /var/service/dhcpcd
sudo unlink /var/service/wpa_supplicant
sudo ln -sf /etc/sv/connmand /var/service
sudo ln -sf /etc/sv/iwd /var/service
