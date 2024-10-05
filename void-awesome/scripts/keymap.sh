#!/bin/bash
set -e
echo "[*] Setup Keymap"

# Utilize the PT-BR standard of <'> + <c> = <ç> instead of <ć>
sudo sed -i /usr/share/X11/locale/en_US.UTF-8/Compose -e "s/ć/ç/g" -e "s/Ć/Ç/g"

# dual keyb. layout(us + us international) and toggle with Scroll Lock
sudo tee /etc/X11/xorg.conf.d/91-keyboard.conf >/dev/null <<EOF
Section "InputClass"
    Identifier "keyboard defaults"
    MatchIsKeyboard "yes"
    Option "XkbLayout" "us,us(intl)"
    Option "XkbOptions" "grp:sclk_toggle"
EndSection
EOF
