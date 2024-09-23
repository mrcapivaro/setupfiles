#!/bin/bash
set -e

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

DIRS=("common")
SCRIPTS=()

while [ "$1" != "" ]; do
	case "$1" in
	--no-common)
		unset 'DIRS[0]'
		DIRS=("${DIRS[@]}")
		shift
		;;
	--dirs)
		DIRS+=($(echo "$2" | tr ',' ' '))
		shift 2
		;;
	--scripts)
		SCRIPTS+=($(echo "$2" | tr ',' ' '))
		shift 2
		;;
	*)
		echo "'$1' is not an option"
		exit 1
		;;
	esac
done

run_dir_scripts() {
	local dir="$1"
	for script in "$SCRIPT_DIR/scripts/$dir"/*; do
		. "$script"
	done
}

printf "=== Void Linux setup.sh Start ===\n\n"

for dir in "${DIRS[@]}"; do
	run_dir_scripts "$dir"
done

for script in "$SCRIPT_DIR/scripts"/*.sh; do
	script_name=$(basename "$script" .sh)
	if [[ " ${SCRIPTS[@]} " =~ " $script_name" ]]; then
		. "$script"
	fi
done

printf "\n=== Void Linux setup.sh End ==="
