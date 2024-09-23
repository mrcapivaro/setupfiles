#!/bin/bash
set -e

PACKAGES=(
	"md.obsidian.Obsidian "
	"com.spotify.Client "
	"dev.vencord.Vesktop "
	"io.github.zen_browser.zen"
)

sudo flatpak remote-add \
	--if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub -y "${PACKAGES[@]}"
