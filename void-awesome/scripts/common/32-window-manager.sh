#!/bin/bash
set -e
echo "[*] Setup Window Manager(and compositor)"

sudo xbps-install -y awesome picom
# ensure that the awesome wm starts with dbus-run-yession
sudo sed -i \
    '/^Exec=.*dbus-run-session/!s/\(^Exec=\)\(.*\)/\1dbus-run-session \2/' \
    /usr/share/xsessions/awesome.desktop
# ensure that a installed xfce polkit does not start with awesome
sudo sed -i \
    '/^OnlyShowIn=.*/!s/^NotShowIn=.*/OnlyShowIn=Xfce/' \
    /etc/xdg/autostart/xfce-polkit.desktop
