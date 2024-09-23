#!/bin/bash
set -e

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

run_dir_scripts() {
	local dir="$1"
	for script in "$SCRIPT_DIR/scripts/$dir"/*; do
		. "$script"
	done
}

printf "=== Void Linux setup.sh Start ===\n"

# TODO: transfer packages/ to shell scripts

# TODO: implent --no-common
run_dir_scripts common

while [ "$1" == "" ]; do
	case "$1" in
	--laptop)
		run_dir_scripts laptop
		shift
		;;
	--gaming)
		run_dir_scripts gaming
		shift
		;;
	--*)
    # TODO: remove --
    local match="$1"
		for file in "$SCRIPT_DIR/scripts"/*; do
			if "$file" == "match"; then
				. "$file"
			fi
		done
		;;
	*)
		echo "'$1' is not an option"
		exit 1
		;;
	esac
done

printf "\n=== Void Linux setup.sh End ==="
