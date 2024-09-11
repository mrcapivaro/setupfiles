# mrcapivaro's Void Linux Setup

## Install

Void Linux network base install with `sudo void-installer` through the live xfce4 iso.

### Post Install

1. Add an user if not created(sometimes void-installer does not create an
   user).
2. Enable the dhcpcd service if not enabled:
   ```bash
   sudo ln -s /etc/sv/dhcpcd /var/service/dhcpcd
   ```
   dhcpcd is disable by setup.sh, since it is replaced by conman + iwd
3. Run some fix scripts if needed(e.g:: fix-fonts.sh for fixing 'ugly' fonts
   in browsers).
4. Run the `setup.sh`.
5. `restart` or `poweroff`(`sudo shutdown now` results in an error for some
   reason).

## TODO

- [ ] GPU Drivers

## Interesting Links

- [network options](https://www.reddit.com/r/voidlinux/comments/rapmhh/networkmanager_vs_wpa_supplicant/)
