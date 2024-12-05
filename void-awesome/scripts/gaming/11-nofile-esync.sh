#!/usr/bin/env bash
set -euo pipefail

# Increase the open files limit.
# Fixes errors when trying to play some games.
# https://github.com/lutris/docs/blob/master/HowToEsync.md

echo "[*] Setup Esync"

## Check if needed.
if grep -q "$USER hard nofile 1048576" /etc/security/limits.conf; then
    echo "Esync is already setup."
    exit 0
fi

## Change the limit to 1048576
sudo bash -c "echo '$USER hard nofile 1048576' >> /etc/security/limits.conf"

# Needed in void linux for some reason. Got it from a reddit post.
# I do not remember the source.
sudo bash -c "echo 'session required /lib/security/pam_limits.so' >> /etc/pam.d/login"
sudo bash -c "echo 'session required /lib/security/pam_limits.so' >> /etc/pam.d/lightdm"
