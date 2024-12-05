#!/usr/bin/env bash
set -euo pipefail
echo "[*] Install LuaRocks Packages"

PACKAGES=(
    "lain"
    "vicious"
)

luarocks install "${PACKAGES[@]}"
