#!/bin/bash
set -e
echo "[*] Setup App Armor"

sudo xbps-install -y apparmor

if grep -q "apparmor=1 security=apparmor" /etc/default/grub; then
	echo "AppArmor is already setup"
	exit 0
fi

sudo cp /etc/default/grub /etc/default/grub.bak
sudo sed -i \
	's/^GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& apparmor=1 security=apparmor/' \
	/etc/default/grub
sudo sed -i 's/complain/enforce/' /etc/default/apparmor
sudo update-grub

echo "A reboot is necessary to load apparmor correctly"
