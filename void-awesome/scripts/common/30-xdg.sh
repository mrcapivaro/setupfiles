#!/bin/bash
set -e
echo "[*] Setup XDG"

sudo xbps-install -y \
	xdg-desktop-portal \
	xdg-desktop-portal-gtk \
	xdg-user-dirs \
	dex
