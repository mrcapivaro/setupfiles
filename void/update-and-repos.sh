#!/bin/bash
set -e

sudo xbps-install -Syu
sudo xbps-install -y void-repo-multilib void-repo-nonfree \
  void-repo-multilib-nonfree xtools
