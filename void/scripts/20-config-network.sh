#!/bin/bash
set -e

# src: https://docs.voidlinux.org/config/network/connman.html
if [ -d "/etc/sv/connmand" ]; then
  echo "Preventing DNS overrides by ConnMan"
  echo "==================================="
  echo "Creating: /etc/sv/connmand/conf"
	sudo echo 'OPTS=--nodnsproxy' >/etc/sv/connmand/conf
fi
