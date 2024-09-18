#!/bin/bash
set -e

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

header() {
	local sep=$(printf "%*s" "$(echo -n "$*" | wc -m)" | tr ' ' '-')
	printf "\n$*\n$sep\n"
}

repos_setup() {
	header "Add Repos"
	local packages=(
		"void-repo-nonfree"
		"void-repo-multilib"
		"void-repo-multilib-nonfree"
	)
	sudo xbps-install -y "${packages[@]}"
}

# === Configuration - 3.0 ===
# Setup of Void Linux following the steps in the official void linux handbook.
#
# https://docs.voidlinux.org/config/index.html

# === Package Documentation - 3.1 ===
#
# https://docs.voidlinux.org/config/package-documentation/index.html

# === Firmware - 3.2 ===
#
# https://docs.voidlinux.org/config/firmware.html

# === Locales & Translations - 3.3 ===
#
# https://docs.voidlinux.org/config/locales.html

# === Users & Groups - 3.4 ===
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
	sudo xbps-install -y socklog-void
	sudo ln -sf /etc/sv/nanoklogd /var/service
	sudo ln -sf /etc/sv/socklog-unix /var/service
}

# === rc.conf, rc.local & rc.shutdown - 3.6 ===
#
# https://docs.voidlinux.org/config/rc-files.html

# === Cron - 3.7 ===
#
# https://docs.voidlinux.org/config/cron.html
cron_setup() {
	header "Setup Cron"
	sudo xbps-install -y cronie
	# cronie creates a symlink in /etc/sv named crond to cronie
	sudo ln -sf /etc/sv/crond /var/service
}

# === SSD Trim - 3.8 ===
#
# https://docs.voidlinux.org/config/ssd.html
ssd_setup() {
	header "Setup Cron"
	sudo tee /etc/cron.weekly/fstrim >/dev/null <<EOF
#!/bin/sh
fstrim /
EOF
	sudo chmod +x /etc/cron.weekly/fstrim
}

# === AppArmor - 3.9.1 ===
#
# https://docs.voidlinux.org/config/security/apparmor.html
apparmor_setup() {
	header "Setup AppArmor"
	sudo xbps-install -y apparmor
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
date_setup() {
	header "Setup Date & Time"
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
#
# https://docs.voidlinux.org/config/power-management.html
power_setup() {
	header "Setup Power Management"
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
	header "Setup Network"
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
#   header "Setup Network Filesystem"
# }

# === Session and Seat Management - 3.15 ===
# elogind commands `loginctl` requires polkit installed(conf?) to be ran
# by normal users.
#
# https://docs.voidlinux.org/config/session-management.html
session_setup() {
	header "Setup Session & Seat Management"
	sudo xbps-install -y dbus elogind polkit
	sudo ln -sf /etc/sv/dbus /var/service
	sudo ln -sf /etc/sv/elogind /var/service
	# sudo ln -sf /etc/sv/polkitd /var/service # ?
}

# === Graphics Drivers - 3.16.1 ===
#
# https://docs.voidlinux.org/config/graphical-yession/graphics-drivers/index.html
gpu_setup() {
	header "Setup Graphics Drivers"
	if lspci | grep -qi "nvidia"; then
		sudo xbps-install -y nvidia nvidia-libs-32bit
	fi
}

# === Xorg - 3.16.2 ===
#
# https://docs.voidlinux.org/config/graphical-yession/xorg.html
xorg_setup() {
	header "Setup XDG"
	sudo xbps-install -y xorg xclip
	# force modesetting drivers
	#   sudo mkdir -p /etc/X11/xorg.conf.d/
	#   sudo tee /etc/X11/xorg.conf.d/10-modesetting.conf >/dev/null <<EOF
	# Section "Device"
	#   Identifier "GPU0"
	#   Driver "modesetting"
	# EndSection
	# EOF
}

# === Display Manager & Window Manager ===
dm_wm_setup() {
	header "Setup Display Manager & Window Manager"
	sudo xbps-install lightdm lightdm-gtk-greeter awesome
	# enable display manager service
	sudo ln -sf /etc/sv/lightdm /var/service
	# ensure that the awesome wm starts with dbus-run-yession
	sudo sed -i \
		'/^Exec=.*dbus-run-session/!s/\(^Exec=\)\(.*\)/\1dbus-run-session \2/' \
		/usr/share/xsessions/awesome.desktop
}

# === Fonts - 3.16.4 ===
#
# https://docs.voidlinux.org/config/graphical-yession/fonts.html
fonts_setup() {
	header "Change fonts"
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
# https://docs.voidlinux.org/config/graphical-yession/icons.html
icons_setup() {
	header "Change icons"
	sudo xbps-install -y gtk+ gtk+3 gtk4 papirus-icon-theme
}

# === Cursor ===
#
# Requires changes in ~/.xinitrc and ~/.Xresources also
cursor_setup() {
	header "Change cursor"
	sudo xbps-install -y breeze-cursors
	# Change Mouse Cursor Theme
	local cursor_conf_dir=/usr/share/icons
	sudo mkdir -p "$cursor_conf_dir/default"
	sudo cp "$cursor_conf_dir/Breeze_Obsidian/index.theme" "$cursor_conf_dir/default"
}

# === XDG - 3.16.6 ===
#
# https://docs.voidlinux.org/config/graphical-yession/portals.html
xdg_setup() {
	header "Setup XDG"
	sudo xbps-install -y xdg-desktop-portal xdg-desktop-portal-gtk dex
	# setup dex
}

# === Multimedia - Pipewire - 3.17.2 ===
#
# https://docs.voidlinux.org/config/media/pipewire.html
audio_setup() {
	header "Setup Audio with Pipewire & Integrations"
	sudo xbps-install -y pipewire alsa-utils pulseaudio-utils pavucontrol alsa-pipewire
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
#
# https://docs.voidlinux.org/config/bluetooth.html
bluetooth_setup() {
	header "Setup Bluetooth"
	# rfkill | grep -q "bluetooth.* blocked" && rfkill unblock bluetooth
	sudo xbps-install -y libspa-bluetooth bluez blueman # blueman?
	sudo ln -sf /etc/sv/bluetoothd /var/service
}

# === Printing - 3.21 ===
#
# https://docs.voidlinux.org/config/print/index.html
printing_setup() {
	header "Setup Printing"
	sudo xbps-install -y cups cups-filters hplip
	sudo ln -sf /etc/sv/cupsd /var/service
	echo "Run hp-setup -i to finish printing drivers install"
}

# === Mouse ===
mouse_setup() {
	header "Setup Mouse"
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
	printf "=== Void Linux setup.sh Start ===\n"

	repos_setup
	cron_setup
	apparmor_setup
	date_setup
	session_setup
	gpu_setup
	xorg_setup
	dm_wm_setup
	fonts_setup
	icons_setup
	cursor_setup
	xdg_setup
	audio_setup
	printing_setup
	mouse_setup

	while [ "$1" != "" ]; do
		case "$1" in
		--bluetooth)
			bluetooth_setup
			shift
			;;
		--laptop)
			power_setup
			shift
			;;
		--ssd)
			ssd_setup
			shift
			;;
		*)
			shift
			;;
		esac
	done

	printf "\n=== Void Linux setup.sh Finish ==="
}

main | tee "$SCRIPT_DIR/last-setup.log"
