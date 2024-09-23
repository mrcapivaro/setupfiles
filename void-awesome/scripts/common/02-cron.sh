#!/bin/bash
set -e
echo "[*] Setup Cron"

sudo xbps-install -y cronie
sudo ln -sf /etc/sv/crond /var/service
