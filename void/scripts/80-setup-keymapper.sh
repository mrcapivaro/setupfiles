#!/bin/bash
set -e

VERSION="4.8.2"
NAME="keymapper"
BIN_URL="https://github.com/houmain/$NAME/releases/download/$VERSION/$NAME-$VERSION-Linux.tar.gz"
TMP="/tmp/keymapper"
ARCHIVE="$TMP/$NAME.tar.gz"

# Create the temporary directory
if [ ! -d "$TMP" ]; then
	echo "Creating: $TMP"
	mkdir -p "$TMP"
fi

# Download the archive
if [ ! -e "$ARCHIVE" ]; then
	echo "Downloading: $ARCHIVE"
	curl -L "$BIN_URL" -o "$ARCHIVE"
fi

# Extract the archive
if [ -e "$ARCHIVE" ]; then
	echo "Extracting: $ARCHIVE"
	tar -xzf "$ARCHIVE" -C "$TMP"
	# Move the binaries
	echo "Moving: binaries to /usr/bin"
	sudo find "$TMP/$NAME-$VERSION-Linux/bin" -type f -name "$NAME*" -exec mv {} /usr/bin/ \;
fi

# Config keymapperd service
if [ ! -d "/etc/sv/keymapperd" ]; then
  if [ -d "$HOME/.config/sv/system/keymapperd" ]; then
    echo "Copying keymapperd config files to /etc/sv and symlinking to /var/service."
    sudo cp -r "$HOME/.config/sv/system/keymapperd" /etc/sv
    sudo ln -s /etc/sv/keymapperd /var/service
  else
    echo "No config files for the keymapperd found, skipping config of keymapperd."
  fi
fi

# Clean up
if [ -d "$TMP" ]; then
	echo "Deleting: $TMP"
	rm -rf "$TMP"
fi
