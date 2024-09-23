#!/bin/bash
set -e
echo "[*] Setup Cursors"

sudo xbps-install -y breeze-cursors
CURSOR_CONF_DIR=/usr/share/icons
sudo mkdir -p "$CURSOR_CONF_DIR/default"
sudo tee "$CURSOR_CONF_DIR/default/index.theme" >/dev/null <<EOF
[Icon Theme]
Inherits=Breeze_Obsidian
EOF
sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee /etc/X11/xorg.conf.d/90-cursor.conf >/dev/null <<EOF
Section "InputClass"
    Identifier "My Cursor"
    MatchIsPointer "yes"
    Driver "libinput"
    Option "CursorTheme" "Breeze_Obsidian"
EndSection
EOF
