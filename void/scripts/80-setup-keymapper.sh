#!/bin/bash
set -e

VERSION="4.8.2"
NAME="keymapper"
BIN_URL="https://github.com/houmain/$NAME/releases/download/$VERSION/$NAME-$VERSION-Linux.tar.gz"
TMP="/TMP/keymapper"
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
	find "$TMP" -type f -name "$NAME*" -exec mv {} /usr/bin/ \;
fi

# Clean up
if [ -d "$TMP" ]; then
	echo "Deleting: $TMP"
	rm -rf "$TMP"
fi
