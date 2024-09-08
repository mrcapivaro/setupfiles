#!/bin/bash

help() {
  cat << EOF
  Setup script for void-linux
  EOF
}

packages() { }

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
