#!/usr/bin/env bash
set -euo pipefail

echo "[*] Setup logging"

sudo xbps-install -y socklog-void
sudo ln -sf /etc/sv/nanoklogd /var/service
sudo ln -sf /etc/sv/socklog-unix /var/service
