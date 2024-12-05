#!/usr/bin/env bash
set -euo pipefail

echo "[*] Add nonfree and multilib repos"

repos=(
    "void-repo-nonfree"
    "void-repo-multilib"
    "void-repo-multilib-nonfree"
)

sudo xbps-install -y "${repos[@]}"
sudo xbps-install -S
