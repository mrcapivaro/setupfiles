#!/bin/bash
set -e

#       Void Linux setup.sh
# src.: https://docs.voidlinux.org/config/index.html
#

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

update_and_add_repos_xbps() {
	echo ""
	echo "Update System & Add Repos"
	echo "---"
	sudo xbps-install -Syu
	sudo xbps-install -Sy void-repo-multilib void-repo-nonfree void-repo-multilib-nonfree
}

#       Cron - 3.7
# src.: https://docs.voidlinux.org/config/cron.html
# dsc.: cronie
setup_cron() {
	echo ""
	echo "Setup Cron"
	echo "---"
	sudo xbps-install -Sy cronie
	# cronie creates a symlink in /etc/sv named crond to cronie
	sudo ln -sf /etc/sv/crond /var/service
	# src: https://docs.voidlinux.org/config/ssd.html
	echo "If you are using a SSD, consider configuring fstrim."
}

#       AppArmor - 3.9.1
# src.: https://docs.voidlinux.org/config/security/apparmor.html
setup_apparmor() {
	echo ""
	echo "Setup AppAmor"
	echo "---"
}

#       Date & Time - 3.10
# src.: https://docs.voidlinux.org/config/date-time.html
setup_time() {
	echo ""
	echo "Setup Date & Time"
	echo "---"
	# ensure correct localtime
	local my_locatime=/usr/share/zoneinfo/America/Sao_Paulo
	sudo ln -sf "$my_locatime" /etc/localtime
	# ensure that hardware clock uses localtime instead of utf, since
	# windows uses localtime and not utf
	sudo sed -i 's/\(^#\)\(HARDWARECLOCK=\).*/\2localtime/' /etc/rc.conf
	# install a ntdp package and enable it's service
	sudo xbps-install -Sy chrony
	sudo ln -sf /etc/sv/chronyd /var/service
}

#       Kernel - 3.11

#       Power Management - 3.12
# src.: https://docs.voidlinux.org/config/date-time.html
setup_time() {
	echo ""
	echo "Setup Power Management"
	echo "---"
	sudo xbps-install -Sy tlp tlpui acpid elogind
}

#       Session and Seat Management
# src.: https://docs.voidlinux.org/config/session-management.html
setup_session() {
	echo ""
	echo "Setup Power Management"
	echo "---"
	sudo xbps-install elogind dbus
}

#       Display Manager & Window Manager
# src.: https://docs.voidlinux.org/config/session-management.html
setup_dm_wm() {
	echo ""
	echo "Setup Display Manager & Window Manager"
	echo "---"
	sudo xbps-install sddm awesome
	# enable display manager service
	sudo ln -sf /etc/sv/sddm /var/service
	# ensure that the awesome wm starts with dbus-run-session
	sudo sed -i \
		'/^Exec=.*dbus-run-session/!s/\(^Exec=\)\(.*\)/\1dbus-run-session \2/' \
		/usr/share/xsessions/awesome.desktop
}

#       Multimedia - Pipewire - 3.17.2
# src.: https://docs.voidlinux.org/config/media/pipewire.html
# dsc.: pipewire + pulseaudio int. + alsa int.
# req.: dbus user session bus         -> correct dm & wm config solves
#       XDG_RUNTIME_DIR defined       -> elogind solves
#       user with audio & video group -> elogind solves
multimedia_pipewire() {
	echo ""
	echo "Setup Audio with Pipewire & Integrations"
	echo "---"
	sudo xbps-install -Sy pipewire alsa-utils pulseaudio-utils pavucontrol
	# enable wireplumber session manager
	sudo mkdir -p /etc/pipewire/pipewire.conf.d
	sudo ln -sf /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
	# Enable pipewire-pulseaudio integration
	sudo ln -sf /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
	# Add pipewire to system XDG autostart directory
	sudo ln -sf /usr/share/applications/pipewire.desktop /etc/xdg/autostart/
	# alsa integration
	sudo mkdir -p /etc/alsa/conf.d
	sudo ln -sf /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
	sudo ln -sf /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d
}

setup_xdg() {
	echo ""
	echo "Setup XDG"
	echo "---"
	sudo xbps-install -Sy xdg-desktop-portal
	# setup dex
}

setup_mouse() {
	echo ""
	echo "Setup Mouse"
	echo "---"
	sudo xbps-install -Sy piper libratbag
	sudo ln -sf /etc/sv/ratbagd /var/service
	# disable mouse acceleration
	sudo mkdir -p /etc/X11/xorg.conf.d
	sudo tee "/etc/X11/xorg.conf.d/40-libinput.conf" >/dev/null <<EOF
Section "InputClass"
  Identifier "libinput pointer catchall"
  MatchIsPointer "on"
  MatchDevicePath "/dev/input/event*"
  Driver "libinput"
  Option "AccelProfile" "flat"
EndSection
EOF
}

change_appearance() {
	sudo xbps-install -Sy breeze-cursors
}

setup_fonts() {
	local home_fonts_dir="$HOME/.local/share/fonts"
	local chezmoi_fonts_dir="$HOME/.local/share/chezmoi/.other/fonts"
	if [ -d "$HOME/.local/share/chezmoi/.other/fonts/iosevka-capy" ]; then
		cp "$HOME/.local/share/chezmoi/.other/fonts/iosevka-capy"/* "$HOME/.local/share/fonts"
	fi
	sudo ln -sf /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
	sudo xbps-reconfigure -f fontconfig
}

main() {
	echo "=== Void Linux setup.sh Start ==="

	# update_and_add_repos_xbps
	# setup_cron
	# setup_apparmor
	# setup_time
	# setup_power
	# multimedia_pipewire
  setup_dm_wm
	# setup_xdg
	# setup_mouse
	# change_appearance
	# setup_fonts

	echo ""
	echo "=== Void Linux setup.sh Finish ==="
}

main | tee .log
