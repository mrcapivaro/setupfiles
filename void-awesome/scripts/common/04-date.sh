#!/bin/bash
set -e
echo "[*] Setup Date & Time"

# ensure correct localtime
# MY_LOCALTIME=/usr/share/zoneinfo/America/Sao_Paulo
# sudo ln -sf "$MY_LOCALTIME" /etc/localtime

# ensure that hardware clock uses localtime instead of utf
sudo sed -i 's/^#\(HARDWARECLOCK=\).*/\1/' /etc/rc.conf
sudo sed -i 's/\(HARDWARECLOCK=\).*/\1localtime/' /etc/rc.conf

# install a ntdp package and enable it's service
sudo xbps-install -y chrony
sudo ln -sf /etc/sv/chronyd /var/service
