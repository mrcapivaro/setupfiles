#!/usr/bin/env bash
set -euo pipefail
echo "[*] Setup Power Management"

sudo xbps-install -y acpi tlp tlpui

sudo ln -sf /etc/sv/acpid /var/service
sudo ln -sf /etc/sv/tlp /var/service

# disable elogind acpid management
sudo mkdir -p /etc/elogind/logind.conf.d
sudo tee /etc/elogind/logind.conf.d/60-disable-acpid-events.conf >/dev/null <<EOF
[Login]
HandlePowerKey=ignore
HandlePowerKeyLongPress=ignore
HandleRebootKey=ignore
HandleRebootKeyLongPress=ignore
HandleSuspendKey=ignore
HandleSuspendKeyLongPress=ignore
HandleHibernateKey=ignore
HandleHibernateKeyLongPress=ignore
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF
