#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

help() {
  cat << EOF
  ./setup.sh options arguments
  EOF
}

packages() {
  sudo xargs -a "$SCRIPT_DIR/packages/meta/packages.txt" xbps-install -Sy
}

configfiles() { }

while [ "$1" != "" ]; do
  case $1 in
    -sync)
      echo "sync packages"
    *)
      echo "Unknown option: $1"
      help
      ;;
  esac
  shift
done
