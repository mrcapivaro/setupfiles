#!/usr/bin/env bash
set -euo pipefail

echo "[*] Setup Theming(GTK & QT)"

packages=(
    "gtk+"
    "gtk+3"
    "gtk4"
    "breeze"
    "breeze-gtk"
    #
    "papirus-icon-theme"
    #
    "breeze-cursors"
    # 
    "freefont-ttf"
    "nerd-fonts"
    "noto-fonts-cjk"
    "noto-fonts-ttf"
    # Gruvbox theme for GTK, KDE, icons and cursor.
    "gnome-themes-extra"
    "gnome-themes-extra-gtk"
    "gtk-engine-murrine"
    "sassc"
)

## Fonts
# Disable bitmap fonts.
if [ ! -e "/etc/fonts/conf.d/70-no-bitmaps.conf" ]; then
    sudo ln -sf /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
    sudo xbps-reconfigure -f fontconfig
fi

## Cursor
cursor_conf_dir=/usr/share/icons
sudo mkdir -p "$cursor_conf_dir/default"

sudo tee "$cursor_conf_dir/default/index.theme" >/dev/null <<EOF
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

## Icons
# ???

sudo xbps-install -y "${packages[@]}"
