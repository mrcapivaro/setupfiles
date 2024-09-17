#!/bin/bash
set -e

# SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

header() {
  echo ""
  echo "$@"
  echo "---"
}

update_and_add_repos_xbps() {
	header "Update system, add repos & other void tools"
	sudo xbps-install -Syu
	sudo xbps-install -y void-repo-multilib void-repo-nonfree \
		void-repo-multilib-nonfree xtools
}

# === Configuration - 3.0 ===
# Setup of Void Linux following the steps in the official void linux handbook.
#
# https://docs.voidlinux.org/config/index.html

# === Package Documentation - 3.1 ===
# Many packages have their documentation stored at `/usr/share/doc/<package>`.
# Some packages have a separate package containing it's documentation. They are
# named as <package>-doc.
#
# https://docs.voidlinux.org/config/package-documentation/index.html

# === Firmware - 3.2 ===
# AMD microcode package does not need configuration.
# Intel microcode package needs configuration:
#     - Regenerate `initramfs`;
# I believe that all of this is done automatically on a fresh void-installer
# setup, but I'm not sure. Might need to use `lscpu | grep -q "Intel/AMD" && \
# sudo xbps-reconfigure --force linux-<version>` to
# determine the cpu and act accordingly.
#
# https://docs.voidlinux.org/config/firmware.html

# === Locales & Translations - 3.3 ===
#
# https://docs.voidlinux.org/config/locales.html

# === Users & Groups - 3.4 ===
# Sometimes, the void-installer helper does not create an user.
#
# https://docs.voidlinux.org/config/users-and-groups.html

# === Services & Daemons (Runit) - 3.5 ===
#
# https://docs.voidlinux.org/config/services/index.html

# === Logging 3.5.2 ===
#
# https://docs.voidlinux.org/config/services/logging.html
setup_logging() {
  header "Setup Logging"
  sudo ln -sf /etc/sv/nanoklogd /var/service
  sudo ln -sf /etc/sv/socklog-unix /var/service
}

# === rc.conf, rc.local & rc.shutdown - 3.6 ===
#
# https://docs.voidlinux.org/config/rc-files.html

# === Cron - 3.7 ===
# There are multiple cron implementations to choose from.
# I chose `cronie`.
#
# https://docs.voidlinux.org/config/cron.html
setup_cron() {
	echo ""
	echo "Setup Cron"
	echo "---"
	sudo xbps-install -y cronie
	# cronie creates a symlink in /etc/sv named crond to cronie
	sudo ln -sf /etc/sv/crond /var/service
}

# === SSD Trim - 3.8 ===
#
# https://docs.voidlinux.org/config/ssd.html
setup_ssd_trim() {
	echo ""
	echo "Setup Cron"
	echo "---"
	sudo tee /etc/cron.weekly/fstrim >/dev/null <<EOF
#!/bin/sh
fstrim /
EOF
	sudo chmod +x /etc/cron.weekly/fstrim
}

# === AppArmor - 3.9.1 ===
#
# https://docs.voidlinux.org/config/security/apparmor.html
setup_apparmor() {
	echo ""
	echo "Setup AppArmor"
	echo "---"
  sudo xbps-install -s apparmor
	if ! grep -q "apparmor=1 security=apparmor" /etc/default/grub; then
		sudo cp /etc/default/grub /etc/default/grub.bak
		sudo sed -i \
			's/^GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& apparmor=1 security=apparmor/' \
			/etc/default/grub
		sudo sed -i 's/complain/enforce/' /etc/default/apparmor
		sudo update-grub
		echo "A reboot is necessary to load apparmor correctly"
	fi
}

# === Date & Time - 3.10 ===
#
# https://docs.voidlinux.org/config/date-time.html
setup_time() {
	echo ""
	echo "Setup Date & Time"
	echo "---"
	# ensure correct localtime
	local my_localtime=/usr/share/zoneinfo/America/Sao_Paulo
	sudo ln -sf "$my_localtime" /etc/localtime
	# ensure that hardware clock uses localtime instead of utf
	sudo sed -i 's/^#\(HARDWARECLOCK=\)/\1/' /etc/rc.conf
	sudo sed -i 's/\(HARDWARECLOCK=\).*/\1localtime/' /etc/rc.conf
	# install a ntdp package and enable it's service
	sudo xbps-install -y chrony
	sudo ln -sf /etc/sv/chronyd /var/service
}

# === Kernel - 3.11 ===
#
# https://docs.voidlinux.org/config/kernel.html

# === Power Management - 3.12 ===
# laptop only.
# enabling acpid requires to disable elogind management of certain events.
#
# https://docs.voidlinux.org/config/power-management.html
setup_power() {
	echo ""
	echo "Setup Power Management"
	echo "---"
	sudo xbps-install -y acpid tlp tlpui
	# disable elogind acpid management
	sudo mkdir -p /etc/elogind/logind.conf.d
	sudo tee /etc/elogind/logind.conf.d/60-disable-acpid-events.conf >/dev/null <<EOF
[Login]
HandlePowerKey=ignore
HandlePowerKeyLongPress=ignore
HandleRebootKey=ignore
HandleRebootKeyLongPress=ignore
HandleSuspendKey=ignore
HandleSuspendKeyLongPress=ignore
HandleHibernateKey=ignore
HandleHibernateKeyLongPress=ignore
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF
}

# === Network - 3.13 ===
#
# https://docs.voidlinux.org/config/network/index.html
setup_network() {
	echo ""
	echo "Setup Network"
	echo "---"
	sudo xbps-install -y connman connman-ncurses cmst iwd runnit-iptables
	sudo unlink /var/service/dhcpcd
	sudo unlink /var/service/wpa_supplicant
	sudo ln -sf /etc/sv/connmand /var/service
	sudo ln -sf /etc/sv/iwd /var/service
}

# === Network Filesystems - 3.14 ===
#
# https://docs.voidlinux.org/config/network-filesystems.html
# setup_nfs() {
#   echo ""
#   echo "Setup Network Filesystem"
#   echo "---"
# }

# === Session and Seat Management - 3.15 ===
# elogind commands `loginctl` requires polkit installed(conf?) to be ran
# by normal users.
#
# https://docs.voidlinux.org/config/session-management.html
setup_session() {
	echo ""
	echo "Setup Session & Seat Management"
	echo "---"
	sudo xbps-install -y dbus elogind polkit
	sudo ln -sf /etc/sv/dbus /var/service
	sudo ln -sf /etc/sv/elogind /var/service
	# sudo ln -sf /etc/sv/polkitd /var/service # ?
}

# === Graphics Drivers - 3.16.1 ===
#
# https://docs.voidlinux.org/config/graphical-session/graphics-drivers/index.html
setup_graphics_drivers() {
	echo ""
	echo "Setup Graphics Drivers"
	echo "---"
	if lspci | grep -qi "nvidia"; then
		sudo xbps-install -s nvidia nvidia-libs-32bit
	fi
}

# === Xorg - 3.16.2 ===
# TODO:
# Check if xorg is using nvidia ppd
#
# https://docs.voidlinux.org/config/graphical-session/xorg.html
setup_xorg() {
	echo ""
	echo "Setup XDG"
	echo "---"
	sudo xbps-install -s xorg xclip
	# force modesetting drivers
	#   sudo mkdir -p /etc/X11/xorg.conf.d/
	#   sudo tee /etc/X11/xorg.conf.d/10-modesetting.conf >/dev/null <<EOF
	# Section "Device"
	#   Identifier "GPU0"
	#   Driver "modesetting"
	# EndSection
	EOF
}

# === Display Manager & Window Manager ===
setup_dm_wm() {
	echo ""
	echo "Setup Display Manager & Window Manager"
	echo "---"
	sudo xbps-install lightdm lightdm-gtk3-greeter awesome
	# enable display manager service
	sudo ln -sf /etc/sv/sddm /var/service
	# ensure that the awesome wm starts with dbus-run-session
	sudo sed -i \
		'/^Exec=.*dbus-run-session/!s/\(^Exec=\)\(.*\)/\1dbus-run-session \2/' \
		/usr/share/xsessions/awesome.desktop
}

# === Fonts - 3.16.4 ===
#
# https://docs.voidlinux.org/config/graphical-session/fonts.html
change_fonts() {
	echo ""
	echo "Change fonts"
	echo "---"
	local home_fonts_dir="$HOME/.local/share/fonts"
	local chezmoi_fonts_dir="$HOME/.local/share/chezmoi/.other/fonts"
	if [ -d "$HOME/.local/share/chezmoi/.other/fonts/iosevka-capy" ]; then
		cp "$HOME/.local/share/chezmoi/.other/fonts/iosevka-capy"/* "$HOME/.local/share/fonts"
	fi
	sudo ln -sf /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
	sudo xbps-reconfigure -f fontconfig
}

# === Icons - 3.16.5 ===
#
# https://docs.voidlinux.org/config/graphical-session/icons.html
change_icons() {
	echo ""
	echo "Change icons"
	echo "---"
	sudo xbps-install -y gtk+ gtk+3 gtk4 papirus-icon-theme
}

# === Cursor ===
#
# Requires changes in ~/.xinitrc and ~/.Xresources also
change_cursor() {
	echo ""
	echo "Change cursor"
	echo "---"
	sudo xbps-install -y breeze-cursors
	# Change Mouse Cursor Theme
	local cursor_conf_dir=/usr/share/icons
	sudo mkdir -p "$cursor_conf_dir/default"
	sudo cp "$cursor_conf_dir/Breeze_Obisidian/index.theme" "$cursor_conf_dir/default"
}

# === XDG - 3.16.6 ===
#
# https://docs.voidlinux.org/config/graphical-session/portals.html
setup_xdg() {
	echo ""
	echo "Setup XDG"
	echo "---"
	sudo xbps-install -y xdg-desktop-portal xdg-desktop-portal-gtk dex
	# setup dex
}

# === Multimedia - Pipewire - 3.17.2 ===
# src.: https://docs.voidlinux.org/config/media/pipewire.html
# dsc.: pipewire + pulseaudio int. + alsa int.
# req.: dbus user session bus         -> correct dm & wm config solves
# === XDG_RUNTIME_DIR defined       -> elogind solves ===
# === user with audio & video group -> elogind solves ===
setup_audio() {
	echo ""
	echo "Setup Audio with Pipewire & Integrations"
	echo "---"
	sudo xbps-install -y pipewire alsa-utils pulseaudio-utils pavucontrol
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

# === Bluetooth - 3.18 ===
# TODO:
# Test on a machine with bluetooth
#
# https://docs.voidlinux.org/config/bluetooth.html
setup_bluetooth() {
	echo ""
	echo "Setup Bluetooth"
	echo "---"
	# rfkill | grep -q "bluetooth.* blocked" && rfkill unblock bluetooth
	sudo xbps-install -s libspa-bluetooth bluez blueman # blueman?
	sudo ln -sh /etc/sv/bluetoothd /var/service
}

# === Printing - 3.21 ===
#
# https://docs.voidlinux.org/config/print/index.html
setup_printing() {
	echo ""
	echo "Setup Printing"
	echo "---"
	sudo xbps-install -s cups cups-filters hplip
	sudo ln -sf /etc/sv/cupsd /var/service
	echo "Run hp-setup -i to finish printing drivers install"
}

# === Mouse ===
setup_mouse() {
	echo ""
	echo "Setup Mouse"
	echo "---"
	sudo xbps-install -y piper libratbag
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

main() {
	echo "=== Void Linux setup.sh Start ==="

	update_and_add_repos_xbps
	setup_cron
	setup_apparmor
	setup_time
	setup_session
	setup_graphics_drivers
	setup_xorg
	setup_dm_wm
	change_fonts
	change_icons
	change_cursor
	setup_xdg
	setup_audio
	setup_printing
	setup_mouse

	# setup_ssd_trim # ssd only
	# setup_power # laptop only
	# setup_bluetooth

	echo ""
	echo "=== Void Linux setup.sh Finish ==="
}

main | tee setup.log
