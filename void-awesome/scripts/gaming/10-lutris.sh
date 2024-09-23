#!/bin/bash
set -e
echo "[*] Setup Lutris"

sudo xbps-install -y \
	lutris \
	wine \
	wine-mono \
	protontricks \
	winegui \
	MangoHud
