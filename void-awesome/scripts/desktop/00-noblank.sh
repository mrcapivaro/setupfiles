#!/bin/bash
set -e

sudo tee /etc/X11/xorg.conf.d/80-noblank.conf >/dev/null <<EOF
Section "ServerFlags"
    Option    "BlankTime"  "0"
EndSection

Section "Extensions"
    Option    "DPMS"  "False"
EndSection
EOF
