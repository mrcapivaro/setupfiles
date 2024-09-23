#!/bin/bash
set -e
echo "[*] Add repos"

REPOS=(
	"void-repo-nonfree"
	"void-repo-multilib"
	"void-repo-multilib-nonfree"
)

sudo xbps-install -y "${REPOS[@]}"
sudo xbps-install -S
