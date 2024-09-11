#!/bin/bash
set -e

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

packages() {
	echo ""
	echo "Installing packages"
	echo "==================="

	sudo xbps-install -Sy void-repo-multilib void-repo-nonfree
	awk -F# '!/^#/ { print $1 }' "$SCRIPT_DIR/data/void-packages.conf" |
		xargs sudo xbps-install -Sy

	# awk -F# '!/^#/ { print $1 }' "$SCRIPT_DIR/data/npm-packages.conf" |
	# 	xargs -n1 sudo npm install -g

	flatpak remote-add --if-not-exists \
		flathub https://dl.flathub.org/repo/flathub.flatpakrepo

	awk -F# '!/^#/ { print $1 }' "$SCRIPT_DIR/data/flatpak-packages.conf" |
		xargs -n1 flatpak install --assumeyes flathub

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
	SRC="$SCRIPT_DIR/tests/src"
	TARGET="$SCRIPT_DIR/tests/target"
	SERVICE="$1"

	# echo "SRC: $SRC"
	# echo "TARGET: $TARGET"
	# echo "SERVICE: $SERVICE"
	# echo "PATH: $SRC/$SERVICE"

	if [ -d "$SRC/$SERVICE" ]; then
		if [ -d "$TARGET/$SERVICE" ]; then
			echo "Skipping: $SERVICE (already enabled)"
		else
			echo "Enabling: $SERVICE"
			ln -s "$SRC/$SERVICE" "$TARGET/$SERVICE"
		fi
	else
		echo "Skipping: $SERVICE (service not found)"
	fi
}

services() {
	echo ""
	echo "Config Services"
	echo "================="

	ENABLED_SERVICES=$(awk -F# '!/^#/ { print $1 }' "$SCRIPT_DIR/data/enabled-services.conf")
	DISABLED_SERVICES=$(awk -F# '!/^#/ { print $1 }' "$SCRIPT_DIR/data/disabled-services.conf")

	echo "$ENABLED_SERVICES" | xargs echo
	# while IFS= read -r service; do
	# 	[ -z "$service" ] && continue
	# 	echo "$service"
	# 	# enable_service "$service"
	#  done < "$ENABLED_SERVICES"

	# while IFS= read -r service; do
	# 	disable_service "$service"
	# done < <(awk -F# '!/^#/ { print $1 }' "$SCRIPT_DIR/data/disabled-services.conf")
}

main() {
	echo "Void Linux Setup Script"
	echo "======================="

	# sudo xbps-install -Syu
	packages
	# configfiles
	# services

	echo ""
	echo "Finished"
	echo "========"
}

main | tee .setuplog
