#!/bin/bash
set -e
echo "[*] Setup Printing"

sudo xbps-install -y cups cups-filters hplip
sudo ln -sf /etc/sv/cupsd /var/service
echo "Run hp-setup -i to finish printing drivers install"
