#!/bin/bash
set -e

CONFIG_PATH="$HOME/.config/firefox"
DEFAULT_PROFILE=$(
	cat ~/.mozilla/firefox/installs.ini | /
	awk '/Default=/' | /
	sed -e 's/Default=//'
)
PROFILE_PATH="$HOME/.mozilla/firefox/$DEFAULT_PROFILE"

if [ -e "$CONFIG_PATH/user.js" ]; then
	echo "Creating the user.js symlink."
	ln -sf "$CONFIG_PATH/user.js" "$PROFILE_PATH/user.js"
else
	echo "The user.js config file does not exist."
fi

if [ -d "$CONFIG_PATH/chrome" ]; then
	echo "Creating the chrome/ symlink."
	ln -sf "$CONFIG_PATH/chrome" "$PROFILE_PATH/chrome"
else
	echo "The chrome/ config folder does not exist."
fi
