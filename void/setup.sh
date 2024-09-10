#!/bin/bash
set -e

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

packages() {
	echo ""
	echo "Installing packages"
	echo "==================="

	awk -F# '!/^#/ { print $1 }' "$SCRIPT_DIR/data/void-packages.txt" |
		xargs sudo xbps-install -Sy

	awk -F# '!/^#/ { print $1 }' "$SCRIPT_DIR/data/npm-packages.txt" |
		xargs -n1 sudo npm install -g

	flatpak remote-add --if-not-exists \
		flathub https://dl.flathub.org/repo/flathub.flatpakrepo

	awk -F# '!/^#/ { print $1 }' "$SCRIPT_DIR/data/flatpak-packages.txt" |
		xargs -n1 flatpak install -assumeyes flathub

	rustup default stable
}

configfiles() {
	echo ""
	echo "Installing Non-Home Configuration Files"
	echo "======================================="

	CONFIGS_DIR="$SCRIPT_DIR/configs"

	for configfile in $(find "$CONFIGS_DIR" -type f); do
		FILENAME=$(basename "$configfile")
		DEST_DIR=$(dirname "$configfile" | sed -e "s|$CONFIGS_DIR||")
		FILE_DIR="$DEST_DIR/$FILENAME"

		if [ ! -d "$DEST_DIR" ]; then
			echo "Creating Directory: $DEST_DIR"
			sudo mkdir -p "$DEST_DIR"
		fi

		if [ -e "$FILE_DIR" ]; then
			if cmp -s "$configfile" "$FILE_DIR"; then
				echo "Skipping: $FILENAME (no changes detected)"
			else
				echo "Renaming: $FILENAME to $FILENAME.bak"
				sudo mv -f "$FILE_DIR" "$FILE_DIR.bak"
				echo "Copying: $configfile to $DEST_DIR"
				sudo cp -f "$configfile" "$FILE_DIR"
			fi
		else
			echo "Copying: $configfile to $DEST_DIR"
			sudo cp -f "$configfile" "$FILE_DIR"
		fi
	done
}

enable_service() {
	# SRC="/etc/sv"
	# TARGET="/var/service"
	SRC="$SCRIPT_DIR/src"
	TARGET="$SCRIPT_DIR/tgt"
	SERVICE="$1"
	if [ -d "$SRC/$SERVICE" ]; then
		if [ -d "$TARGET/$SERVICE" ]; then
			echo "Skipping: $SERVICE (already enabled)"
		else
			echo "Enabling: $SERVICE"
			ln -s "$SRC/$SERVICE" "$TARGET/$SERVICE"
		fi
	else
		echo "$SRC"
		echo "Skipping: $SERVICE (service not found)"
	fi
}

services() {
	echo ""
	echo "Enabling Services"
	echo "================="

	# TODO: reason why this does not work
	# SERVICES=$(awk -F# '!/^#/ { print $1 }' "$SCRIPT_DIR/data/enabled-services.txt")
	# for service in "$SERVICES"; do
	# 	enable_service "$service"
	# done

	while IFS= read -r service; do
		enable_service "$service"
	done < <(awk -F# '!/^#/ { print $1 }' "$SCRIPT_DIR/data/enabled-services.txt")
}

main() {
	echo "Void Linux Setup Script"
	echo "======================="

	# packages
	# configfiles
	services

	echo ""
	echo "Finished"
	echo "========"
}

main | tee .setuplog
