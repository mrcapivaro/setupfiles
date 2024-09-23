#!/bin/bash
set -e
echo "[*] Setup Keymap"

# Utilize the PT-BR standard of <'> + <c> = <ç> instead of <ć>
sudo sed -i /usr/share/X11/locale/en_US.UTF-8/Compose -e "s/ć/ç/g" -e "s/Ć/Ç/g"
