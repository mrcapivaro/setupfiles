#!/bin/bash
set -e

# ensure existance of the pipewire cong directory
if [ ! -d "/etc/pipewire/pipewire.conf.d" ]; then
	echo "Creating: pipewire.conf.f directory"
	sudo mkdir -p /etc/pipewire/pipewire.conf.d
fi

# enable wireplumber session manager
sudo ln -s /usr/share/examples/pipewire/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/

# Enable pipewire-pulseaudio integration
sudo ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/

# Add pipewire to xdg autostart
sudo ln -s /usr/share/applications/pipewire.desktop /etc/xdg/autostart/

# ensure existance of the alsalib config directory
if [ ! -d "/usr/share/alsa/alsa.conf.d" ]; then
	echo "Creating: pipewire.conf.f directory"
	sudo mkdir -p /usr/share/alsa/alsa.conf.d
fi

# alsa integration
sudo ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
sudo ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d
