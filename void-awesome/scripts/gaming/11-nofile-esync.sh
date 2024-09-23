#!/bin/bash
set -e
echo "[*] Setup Esync"

# Needed: Increase the open files limit
# Sources(s).:
# - Lutris: https://github.com/lutris/docs/blob/master/HowToEsync.md

if grep -q "hard nofile" /etc/security/limits.conf; then
	echo "Esync is already setup."
	exit 0
fi

# Change the limit to 1048576
sudo tee -a /etc/security/limits.conf >/dev/null <<EOF
$USER hard nofile 1048576
EOF

sudo tee -a /etc/pam.d/login >/dev/null <<EOF
session required /lib/security/pam_limits.so
EOF

# The name of the file after pam.d/ should be the name of the used DM
sudo tee -a /etc/pam.d/lightdm >/dev/null <<EOF
session required /lib/security/pam_limits.so
EOF
