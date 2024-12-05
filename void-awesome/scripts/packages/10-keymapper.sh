#!/usr/bin/env bash
set -euo pipefail

version=$(curl -s https://api.github.com/repos/houmain/keymapper/releases | jq ".[0].tag_name")
name="keymapper-$version-Linux"
url="https://github.com/houmain/keymapper/releases/download/$version/$name.tar.gz"

echo "Trying to install <https://github.com/houmain/keymapper>."

## Check if needed
if keymapper --version | grep -q "$version"; then
    echo "Keymapper $version is already installed."
    exit 0
fi

## Temporary folder
tmp_dir=$(mktemp -d)
trap 'rm -rf $tmp_dir' INT HUP EXIT
out_dir="$tmp_dir/$name"
echo "Creating temporary folder '$tmp_dir'."

## Download
echo "Downloading archive."
curl -fsSL "$url" -O "$tmp_dir"

## Extract
echo "Extracting archive."
tar -xf "$out_dir.tar.gz"

## Install
echo "Installing binaries and other files."
sudo install -m 755 "$out_dir/bin"* /usr/local/bin
sudo install -m 644 "$out_dir/share"* /usr/local/share

# Service install depending on the init system used (runit or systemd)
if cat /proc/1/comm | grep -qi "systemd"; then
    sudo install -m 644 "$out_dir/lib"* /usr/local/lib
else if cat /proc/1/comm | grep -qi "runit";then
    if [[ ! -e /var/service/keymapperd/run ]]; then
        echo "Creating and linking runit service for keymapperd."
        if [[ ! -d /etc/sv/keymapperd ]]; then
            sudo mkdir -p /etc/sv/keymapperd
        fi
        if [[ ! -e /etc/sv/keymapperd/run ]]; then
            echo '#!/bin/sh' > /tmp/run
            echo 'exec keymapperd' >> /tmp/run
            sudo mv /tmp/run /etc/sv/keymapperd
        fi
        sudo ln -sf /etc/sv/keymapperd /var/service
    fi
else
    echo "Manually create a service to start keymapperd."
fi

echo "Keymapper install fineshed."
