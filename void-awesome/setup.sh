#!/usr/bin/env bash
set -euo pipefail

script_dir=$(dirname $(readlink -f $0))
dirs=("common")
scripts=()

run_dir_scripts() {
    local root_dir="$1"
    for script in "$root_dir"/*.sh; do
        . "$script"
    done
}

## Argument parsing
while [ $# -ne 0 ]; do
    case "$1" in
        -n | --no-common)
            unset 'dirs[0]'
            dirs=("${dirs[@]}")
            ;;
        -d | --dirs)
            shift
            dirs+=($(echo "$1" | tr ',' ' '))
            ;;
        -s | --scripts)
            shift
            scripts+=($(echo "$1" | tr ',' ' '))
            ;;
        *)
            echo "'$1' is not an option."
            exit 1
            ;;
    esac
    shift
done

## Main
echo "[*] setupfiles"
echo ""

for dir in "${dirs[@]}"; do
    echo "Running scripts inside '$script_dir/scripts/$dir':"
    run_dir_scripts "$script_dir/scripts/$dir"
done

echo ""

for script in "$script_dir/scripts"/*.sh; do
    script_name=$(basename "$script")
    script_name=${script_name#*-}
    if [[ " ${scripts[@]} " =~ "${script_name%.sh}" ]]; then
        echo "Running '$script':"
        . "$script"
    fi
done

exit
