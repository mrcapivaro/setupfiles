#!/usr/bin/env bash
set -euo pipefail

# src.: https://www.reddit.com/r/TeamfightTactics/comments/1cwhg2z/somewhat_workaround_for_linux_players/

echo "[*] Setup Waydroid"

## Install waydroid and a wayland kiosk compositor for X11
PACKAGES=(
    "waydroid"
    # hyprland emulation
    "weston"
    "weston-x11"
    "weston-xwayland"
    # used for clipboard support
    "wl-clipboard"
    "python3-pyclip"
)
sudo xbps-install -y "${PACKAGES[@]}"

## Enable waydroid service and install android image
sudo ln -sf /etc/sv/waydroid-container /var/service
sudo waydroid init -f -s GAPPS

## Use a external script to install some libraries in the image using python.
# src.: https://github.com/casualsnek/waydroid_script
TMP="$(mktemp -d)"
trap "rm -rf '$TMP' 2>/dev/null" EXIT INT TERM
git clone https://github.com/casualsnek/waydroid_script "$TMP"
cd "$TMP"
python -m venv venv
venv/bin/pip install -r requirements.txt
# arm emulation and root tooling
sudo venv/bin/python3 main.py install libhoudini magisk

## Install exec script and config files
cat <<EOF >~/.config/weston.ini
[libinput]
enable-tap=true

[shell]
panel-position=none
EOF

cat <<EOF >~/.local/bin/waydroid-session
#!/usr/bin/env bash

# Start Weston
weston --xwayland &
WESTON_PID=\$!
export WAYLAND_DISPLAY=wayland-1
sleep 2

# Launch Waydroid
waydroid show-full-ui &
WAYDROID_PID=\$!

# Stop Waydroid when Weston exits
trap "waydroid session stop; kill \$WESTON_PID; kill \$WAYDROID_PID" EXIT

wait \$WESTON_PID
EOF
chmod +x ~/.local/bin/waydroid-session

cat <<EOF >~/.local/share/applications/waydroid-session.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Waydroid Session
Comment=Start Waydroid in a Weston session
Exec=/bin/bash -c "cd /usr/bin && ./waydroid-session.sh"
Icon=waydroid
Terminal=false
Categories=System;Emulator;
EOF
chmod +x ~/.local/share/applications/waydroid-session.desktop

## Patch the arm translation layers to fix crashing
# BUG: When opening TFT, all works normally. But, when starting a match, the app
# crashes after the loading screen.
# src.: https://github.com/waydroid/waydroid/issues/788
function CheckHex {
    local path=$1
    local ghidra_offset=$2
    local hex_to_check=$3
    commandoutput=$(od $path --skip-bytes=$(($ghidra_offset - 0x100000)) \
        --read-bytes=$((${#3} / 2)) \
        --endian=little -t x1 -An file | sed 's/ //g')
    if [ "$commandoutput" = "$hex_to_check" ]; then
        echo "1"
    else
        echo "0"
    fi
}

function PatchHex {
    local path=$1
    local ghidra_offset=$2
    local original_hex=$3
    local new_hex=$4
    #file path, ghidra offset, original hex, new hex
    local file_offset=$(($ghidra_offset - 0x100000))
    if [ $(CheckHex $path $ghidra_offset $original_hex) = "1" ]; then
        hexinbin=$(printf $new_hex | xxd -r -p)
        echo -n $hexinbin | dd of=$1 seek=$file_offset bs=1 conv=notrunc
        tmp="Patched $path at $file_offset with new hex $new_hex"
        echo $tmp
    elif [ $(CheckHex $path $ghidra_offset $new_hex) = "1" ]; then
        echo "Already patched"
    else
        echo "Hex mismatch!"
    fi
}

ARM_LAYER="/var/lib/waydroid/overlay/system/lib64/libhoudini.so"

if [ -f $ARM_LAYER ]; then
    if [ -w houdini_path ] || [ "$EUID" = 0 ]; then
        PatchHex $ARM_LAYER 0x4062a5 48b8fbffffff 48b8ffffffff
        PatchHex $ARM_LAYER 0x4099d6 83e0fb 83e0ff
        PatchHex $ARM_LAYER 0x409b42 e8892feeff 9090909090
    else
        echo "Libhoudini is not writeable. Please run with sudo"
    fi
else
    echo "Libhoudini not found. Please install it first."
fi

## Echo some important stuff
echo "Run 'waydroid app install \"/path/to/app\"' to install an app."
echo "Register device: https://docs.waydro.id/faq/google-play-certification"
