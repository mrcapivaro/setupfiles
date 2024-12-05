#!/usr/bin/env bash
set -euo pipefail
echo "[*] Setup Bluetooth"

# rfkill | grep -q "bluetooth.* blocked" && rfkill unblock bluetooth
sudo xbps-install -y libspa-bluetooth bluez blueman
sudo ln -sf /etc/sv/bluetoothd /var/service
