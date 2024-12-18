#!/usr/bin/env bash
set -euo pipefail
echo "[*] Setup Touchpad"

# https://wiki.archlinux.org/title/Touchpad_Synaptics
[[ ! -d /etc/X11/xorg.conf.d ]] && sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee "/etc/X11/xorg.conf.d/76-synaptics.conf" >/dev/null <<EOF
Section "InputClass"
    Identifier "touchpad"
    Driver "synaptics"
    MatchIsTouchpad "on"
        Option "TapButton1" "1"
        Option "TapButton2" "3"
        Option "TapButton3" "2"
        Option "VertEdgeScroll" "on"
        Option "VertTwoFingerScroll" "on"
        Option "HorizEdgeScroll" "on"
        Option "HorizTwoFingerScroll" "on"
        Option "CircularScrolling" "on"
        Option "CircScrollTrigger" "2"
        Option "EmulateTwoFingerMinZ" "40"
        Option "EmulateTwoFingerMinW" "8"
        Option "CoastingSpeed" "0"
        Option "FingerLow" "30"
        Option "FingerHigh" "50"
        Option "MaxTapTime" "125"
EndSection
EOF
