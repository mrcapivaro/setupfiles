#!/usr/bin/env bash
set -euo pipefail

script_dir="$(dirname "$(readlink -f $0)")"
script_name=$(basename $0)

function main() {
    echo "end."
}

function install_paperwm() {
    local tmp_dir=$(mktemp -d)
    trap 'rm -rf $tmp_dir' EXIT INT HUP
    git clone "https://github.com/paperwm/PaperWM" "$tmp_dir"
    "$tmp_dir/install.sh"
}

main "$@"
