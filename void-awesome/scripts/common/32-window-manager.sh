#!/bin/bash
set -e
echo "[*] Setup Window Manager(and compositor)"

sudo xbps-install -y awesome picom
# ensure that the awesome wm starts with dbus-run-yession
sudo sed -i \
	'/^Exec=.*dbus-run-session/!s/\(^Exec=\)\(.*\)/\1dbus-run-session \2/' \
	/usr/share/xsessions/awesome.desktop
