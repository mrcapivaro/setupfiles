#!/bin/bash
set -e

sudo flatpak remote-add \
	--if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub -y \
	md.obsidian.Obsidian \
	com.spotify.Client \
	dev.vencord.Vesktop \
	io.github.zen_browser.zen
