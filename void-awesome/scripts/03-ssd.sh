#!/usr/bin/env bash
set -euo pipefail
echo "[*] Setup SSD Trim"

sudo tee /etc/cron.weekly/fstrim >/dev/null <<EOF
#!/bin/sh
fstrim /
EOF
sudo chmod +x /etc/cron.weekly/fstrim
