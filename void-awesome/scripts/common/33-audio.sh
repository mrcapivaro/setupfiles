#!/usr/bin/env bash
set -euo pipefail
echo "[*] Setup Audio(Pipewire)"

sudo xbps-install -y \
    pipewire \
    alsa-pipewire \
    alsa-utils \
    pulseaudio-utils \
    pavucontrol-qt

# enable wireplumber session manager
sudo mkdir -p /etc/pipewire/pipewire.conf.d
sudo ln -sf \
    /usr/share/examples/wireplumber/10-wireplumber.conf \
    /etc/pipewire/pipewire.conf.d/

# Enable pipewire-pulseaudio integration
sudo ln -sf \
    /usr/share/examples/pipewire/20-pipewire-pulse.conf \
    /etc/pipewire/pipewire.conf.d/

# Add pipewire to system XDG autostart directory
# sudo ln -sf \
# 	/usr/share/applications/pipewire.desktop \
# 	/etc/xdg/autostart/

# alsa integration
sudo mkdir -p /etc/alsa/conf.d
sudo ln -sf \
    /usr/share/alsa/alsa.conf.d/50-pipewire.conf \
    /etc/alsa/conf.d
sudo ln -sf \
    /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf \
    /etc/alsa/conf.d
