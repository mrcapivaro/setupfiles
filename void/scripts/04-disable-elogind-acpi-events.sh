#!/bin/bash
set -e

if [ ! -d /etc/elogind/logind.conf.d ]; then
	echo "Creating: /etc/elogind/logind.conf.d/"
	sudo mkdir -p /etc/elogind/logind.conf.d
fi

if [ ! -d /etc/elogind/logind.conf.d/60-disable-acpid-events.conf ]; then
	echo "Creating: 60-disable-acpid-events.conf"
	sudo touch /etc/elogind/logind.conf.d/60-disable-acpid-events.conf
fi

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
