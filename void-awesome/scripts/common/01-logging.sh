#!/bin/bash
set -e
echo "[*] Setup Logging"

sudo xbps-install -y socklog-void
sudo ln -sf /etc/sv/nanoklogd /var/service
sudo ln -sf /etc/sv/socklog-unix /var/service
