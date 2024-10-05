#!/bin/bash
set -e
echo "[*] Setup Lutris"

sudo xbps-install -y \
	lutris \
	wine \
	wine-32bit \
	mono \
	wine-mono \
	protontricks \
	winetrics \
	winegui \
  mesa \
  mesa-32bit \
  vulkan-loader \
  vulkan-loader-32bit \
	MangoHud
