#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
xargs -a "$SCRIPT_DIR/../packages/flatpak.txt" flatpak install flathub -y
