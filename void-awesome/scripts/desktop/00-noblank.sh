#!/usr/bin/env bash
set -euo pipefail

cat <<EOF > /tmp/80-noblank.conf
Section "ServerFlags"
    Option    "BlankTime"  "0"
EndSection

Section "Extensions"
    Option    "DPMS"  "False"
EndSection
EOF

sudo mv /tmp/80-noblank.conf /etc/X11/xorg.conf.d/
