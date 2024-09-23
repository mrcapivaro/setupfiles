#!/bin/bash
set -e
echo "[*] Setup Fonts"

if [ ! -e "/etc/fonts/conf.d/70-no-bitmaps.conf" ]; then
	sudo ln -sf /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
	sudo xbps-reconfigure -f fontconfig
fi
