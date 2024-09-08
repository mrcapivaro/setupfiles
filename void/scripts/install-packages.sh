#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

sudo xargs -a "$SCRIPT_DIR/../packages/meta/packages.txt" xbps-install -Sy
