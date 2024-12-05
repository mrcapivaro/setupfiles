#!/usr/bin/env bash
set -euo pipefail

function usage() {
    echo "..."
    exit 0
}

function main() {
    parse_args "$@"
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

main "$@"
