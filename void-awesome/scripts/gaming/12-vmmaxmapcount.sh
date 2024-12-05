#!/usr/bin/env bash
set -euo pipefail
echo "[*] Change vm.max_map_count"

sudo mkdir -p /etc/sysctl.d
sudo tee /etc/sysctl.d/99-steamplay.conf >/dev/null <<EOF
vm.max_map_count=262144
EOF
