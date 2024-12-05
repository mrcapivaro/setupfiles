#!/usr/bin/env bash
set -euo pipefail

echo "[*] Setup Window Manager & Compositor"

sudo xbps-install -y awesome picom

# Ensure that the Awesome WM starts with 'dbus-run-session'.
sudo sed -i \
    '/^Exec=.*dbus-run-session/!s/\(^Exec=\)\(.*\)/\1dbus-run-session \2/' \
    /usr/share/xsessions/awesome.desktop
