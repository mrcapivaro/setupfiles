#!/usr/bin/env bash
set -euo pipefail
echo "[*] Setup Mouse"

sudo xbps-install -y piper libratbag
sudo ln -sf /etc/sv/ratbagd /var/service

# disable mouse acceleration
[ ! -d /etc/X11/xorg.conf.d/ ] && sudo mkdir -p  /etc/X11/xorg.conf.d
sudo tee "/etc/X11/xorg.conf.d/40-libinput.conf" >/dev/null <<EOF
Section "InputClass"
    Identifier "libinput pointer catchall"
    MatchIsPointer "on"
    MatchDevicePath "/dev/input/event*"
    Driver "libinput"
    Option "AccelProfile" "flat"
EndSection
EOF
