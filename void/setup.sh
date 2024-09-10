#!/bin/bash

# === Constants ===

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# === Utilities ===

xargs-wrapper() {
	FILE=$1
	shift
	cat "$FILE" | awk -F# '!/^#/ { print $1 }' | xargs $@
}

# === Functions ===

packages() {
	echo "Installing packages"
	echo "==================="
	echo ""
	xargs-wrapper "$SCRIPT_DIR/packages/xbps.txt" sudo xbps-install -Sy
	xargs-wrapper "$SCRIPT_DIR/packages/npm.txt" sudo npm install -g
	flatpak remote-add --if-not-exists \
		flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	xargs-wrapper "$SCRIPT_DIR/packages/flatpak.txt" flatpak install --assumeyes flathub
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
				echo "Renaming: $FILENAME -> $FILENAME.bak"
				sudo mv -f "$FILE_DIR" "$FILE_DIR.bak"
				echo "Copying: $configfile -> $DEST_DIR"
				sudo cp -f "$configfile" "$FILE_DIR"
			fi
		else
			echo "Copying: $configfile -> $DEST_DIR"
			sudo cp -f "$configfile" "$FILE_DIR"
		fi
	done
}

# === Main ===

main() {
	echo "Void Linux Setup Script"
	echo "======================="
	echo ""
	packages
	configfiles
	echo ""
	echo "Finished"
	echo "========"
	echo ""
}

main | tee .setuplog
