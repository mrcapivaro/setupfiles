#!/usr/bin/env bash
set -euo pipefail
echo "[*] Setup Minecraft"

sudo xbps-install -y \
	PrismLauncher \
	openjdk17-jre \
	openjdk21-jre
