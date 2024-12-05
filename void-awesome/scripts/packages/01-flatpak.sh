#!/usr/bin/env bash
set -euo pipefail

PACKAGES=(
    "md.obsidian.Obsidian"
    "com.spotify.Client"
    "dev.vencord.Vesktop"
    "io.github.zen_browser.zen"
    "io.freetubeapp.FreeTube"
    "dev.zed.Zed"
)

sudo flatpak remote-add \
    --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub -y "${PACKAGES[@]}"
