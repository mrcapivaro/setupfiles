#!/bin/bash
set -e

TARGET="/var/service"
SRC="/etc/sv"

enable_service() {
	if [ -d "$SRC"/$1 && ! -d "$TARGET"/$1 ]; then
    echo "Enabling Service: $1"
		sudo ln -s "$SRC"/$1 "$TARGET"/$1
	fi
}

enable_service "tlp"
enable_service "dhcpcd"
