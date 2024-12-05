#!/usr/bin/env bash
set -euo pipefail

echo "[*] Setup cron"

sudo xbps-install -y cronie
sudo ln -sf /etc/sv/crond /var/service
