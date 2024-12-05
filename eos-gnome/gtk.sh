#!/usr/bin/env bash
set -euo pipefail

function usage() {
    echo "Install and configure GTK and it's themes."
    exit 0
}

function main() {

}

function parse_args() {
    while [[ "$1" != "" ]]; do
        case "$1" in
            --*)
                do_something
                ;;
            *)
                echo "Wrong use of arguments."
                echo "Run $0 --help for usage."
                exit 1
                ;;
        esac
        shift
    done
}

function install_gruvbox_theme() {
    # handle dependencies
    local packages=(
        "gnome-themes-extra"
        "gnome-themes-extra-gtk"
        "gtk-engine-murrine"
        "sassc"
    )
    sudo pacman -S --no-confirm ${packages[@]}

    # git clone
    git clone 

    # ensure themes folders
    mkdir -p "$HOME/.themes" # gtk3
    mkdir -p "$HOME/.config/gtk-4.0" # gtk4
}

main "$@"
