#!/bin/bash
set -e
echo "[*] Setup Minecraft"

sudo xbps-install -y \
	prismlauncher \
	openjdk17-jre \
	openjdk21-jre