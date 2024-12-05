#!/usr/bin/env bash
set -euo pipefail

# Skip if already setup.
grep -q "apparmor=1 security=apparmor" /etc/default/grub && exit 0

echo "[*] Setup App Armor"

sudo xbps-install -y apparmor

# Perform certain modifications in the app armor config file.
sudo cp /etc/default/grub /etc/default/grub.bak
apparmor_config="/etc/default/apparmor"
sudo sed -i \
    's/^GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& apparmor=1 security=apparmor/' \
    $apparmor_config
sudo sed -i 's/complain/enforce/' $apparmor_config

sudo update-grub
