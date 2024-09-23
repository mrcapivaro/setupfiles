#!/bin/bash
set -e
echo "[*] Setup XDG"

sudo xbps-install -y xorg xclip
# force modesetting drivers
#   sudo mkdir -p /etc/X11/xorg.conf.d/
#   sudo tee /etc/X11/xorg.conf.d/10-modesetting.conf >/dev/null <<EOF
# Section "Device"
#   Identifier "GPU0"
#   Driver "modesetting"
# EndSection
# EOF
