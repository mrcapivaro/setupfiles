#!/usr/bin/env bash
set -euo pipefail
echo "[*] Setup Steam"

sudo xbps-install -y \
    steam \
    libgcc-32bit \
    libstdc++-32bit \
    libdrm-32bit \
    libglvnd-32bit

# steamtinkerlaunch
# https://www.reddit.com/r/LinuxCrackSupport/comments/tqjp3z/guide_running_steamworks_fixonline_fix_with_linux/
