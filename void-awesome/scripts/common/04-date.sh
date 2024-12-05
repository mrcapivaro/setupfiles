#!/usr/bin/env bash
set -euo pipefail

echo "[*] Setup Date & Time"

# Ensure correct localtime.
# MY_LOCALTIME=/usr/share/zoneinfo/America/Sao_Paulo
# sudo ln -sf "$MY_LOCALTIME" /etc/localtime

# Ensure that hardware clock uses localtime instead of utf.
sudo sed -i 's/^#\(HARDWARECLOCK=\).*/\1/' /etc/rc.conf
sudo sed -i 's/\(HARDWARECLOCK=\).*/\1localtime/' /etc/rc.conf

# Install a ntdp package and enable its service.
sudo xbps-install -y chrony
sudo ln -sf /etc/sv/chronyd /var/service
