#!/bin/bash
set -e
echo "[*] Add repos"

sudo xbps-install -y \
	void-repo-nonfree \
	void-repo-multilib \
	void-repo-multilib-nonfree
