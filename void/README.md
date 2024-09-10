# mrcapivaro's Void Linux Setup

## Install

Void Linux network base install with `sudo void-installer` through the live xfce4 iso.

### Post Install

1. Add an user if not created(sometimes void-installer does not create an
   user).
2. Run some fix scripts if needed(e.g:: fix-fonts.sh for fixing 'ugly' fonts in
   browsers).
3. Run the `setup.sh`.
4. `restart` or `poweroff`(`sudo shutdown now` results in an error for some
   reason).

## TODO

- [ ] [AppArmor](https://www.reddit.com/r/voidlinux/comments/mbghby/apparmor_setupconfig_help/)
