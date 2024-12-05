#!/usr/bin/env bash
set -euo pipefail

echo "[*] Setup Keymap"

# dual keyb. layout(us + us international) and toggle with Scroll Lock
sudo tee /etc/X11/xorg.conf.d/91-keyboard.conf >/dev/null <<EOF
Section "InputClass"
    Identifier "keyboard defaults"
    MatchIsKeyboard "yes"
    Option "XkbLayout" "us,us(intl)"
    Option "XkbOptions" "grp:sclk_toggle"
EndSection
EOF
