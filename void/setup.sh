#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# help() {
#   cat << EOF
#   ./setup.sh options arguments
#   EOF
# }

packages() {
	sudo xargs -a "$SCRIPT_DIR/packages/xbps.txt" xbps-install -Sy
	sudo xargs -a "$SCRIPT_DIR/packages/npm.txt" npm install -g
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	xargs -a "$SCRIPT_DIR/packages/flatpak.txt" flatpak install --assumeyes flathub
  rustup default stable
}

# configfiles() {
#   for file in "$SCRIPT_DIR/configfiles"/*; do
#     REL_DIR=$(readlink -f file | awk 'configfile/*.')
#     sudo cp -rf file $REL_DIR
#   end
# }

main() {
	packages
	configfiles
}

main
