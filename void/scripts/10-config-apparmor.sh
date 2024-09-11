#!/bin/bash
set -e

sudo cp /etc/default/grub /etc/default/grub.bak
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& apparmor=1 security=apparmor/' /etc/default/grub
sudo sed -i 's/complain/enforce/' /etc/default/apparmor
sudo update-grub
echo "A reboot is necessary to load apparmor correctly"
