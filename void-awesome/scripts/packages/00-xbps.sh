#!/usr/bin/env bash
set -euo pipefail

echo "[*] Install XBPS(Void Linux) Packages"

packages=(
    "ntfs-3g"
    "rclone"
    "libayatana-appindicator" # keymapper dep.
    "aria2"

    #{{{1 CLI Apps
    "git"
    "github-cli"
    "lazygit"
    "wget"
    "curl"
    "sed"
    "jq"
    "yq"
    "fzf"
    "fd"
    "ripgrep"
    "bat"
    "less"
    "tldr"
    "nvimpager"
    "glow"
    "tar"
    "gzip"
    "bzip2"
    "xz"
    "p7zip"
    "unrar"
    "zip"
    "unzip"
    "zstd"
    "chezmoi"
    "starship"
    "zoxide"
    "direnv"
    "tmux"
    "zellij"
    "htop"
    "btop"
    "fastfetch"
    "yazi"
    ## Shell
    "fish-shell"
    "zsh"
    ## Neovim
    "neovim"
    # image.nvim deps
    "ImageMagick"
    "libmagick"
    "libmagick-devel"
    #1}}}

    #{{{1 Prog. Lang(s)
    "gcc"
    "lua"
    "lua-devel"
    "LuaJIT"
    "luarocks"
    "nodejs"
    "pnpm"
    "python3"
    "python3-pip"
    "python3-ipython"
    "python3-numpy"
    "python3-scipy"
    "python3-pandas"
    "python3-matplotlib"
    "python3-pyperclip"
    "go"
    "rustup"
    "openssl-devel" # needed for: cargo install cargo-generate
    "arduino"
    "arduino-cli"
    #1}}}

    #{{{1 Build
    "make"
    "cmake"
    "ninja"
    "meson"
    "autoconf"
    "automake"
    "bc"
    "binutils"
    "bison"
    "ed"
    "flex"
    "gettext"
    "groff"
    "libtool"
    "m4"
    "patch"
    "pkg-config"
    "texinfo"
    #1}}}

    #{{{1 System
    "xtools"
    "socklog-void"
    "cronie"
    "apparmor"
    "chrony"
    "dbus"
    "elogind"
    "polkit"
    ## Network
    "connman"
    "connman-ncurses"
    "cmst"
    "iwd"
    "runit-iptables"
    ## Webcam
    "obs"
    "v4l2loopback"
    ## Audio
    "pipewire"
    "alsa-pipewire"
    "alsa-utils"
    "pulseaudio-utils"
    "pavucontrol"
    ## Mouse
    "libratbag"
    "piper"
    ## Printing
    "cups"
    "cups-filters"
    "hplip"
    ## DE
    "xorg"
    "lightdm"
    "lightdm-gtk-greeter"
    "awesome"
    "xclip"
    "picom"
    "dex"
    "wmctrl"
    "rofi"
    "rofi-calc"
    "xdotool"
    "feh"
    "dunst"
    "maim" # improved scrot
    "xbacklight" # TODO: replace with rofi
    "i3lock"   # TODO: replace with rofi
    ## Fonts
    "freefont-ttf"
    "nerd-fonts"
    "noto-fonts-cjk"
    "noto-fonts-ttf"
    ## Cursor and Icons
    "papirus-icon-theme"
    "breeze"
    "breeze-gtk"
    "breeze-cursors"
    ## GTK
    "gtk+"
    "gtk+3"
    "gtk4"
    # gruvbox theme deps.
    "gnome-themes-extra"
    "gnome-themes-extra-gtk"
    "gtk-engine-murrine"
    "sassc"
    ## XDG
    "xdg-desktop-portal"
    "xdg-desktop-portal-gtk"
    "xdg-user-dirs"
    #1}}}

    #{{{1 GUI Apps

    "firefox"
    "chromium"
    "kitty"
    "wezterm"
    "libreoffice"
    "zathura"
    "zathura-pdf-mupdf"
    "flatpak"
    "nemo"            # file manager
    "nemo-fileroller" # context menu compress options

    ## Emacs
    "emacs"
    "emacs-gtk3"

    ## Games
    "steam"
    "lutris"
    "MangoHud"

    # java and minecraft
    "PrismLauncher"
    "openjdk8-jre"
    "openjdk17-jre"
    "openjdk21-jre"

    # wine
    "wine"
    "wine-32bit"
    "mono"
    "wine-mono"
    "protontricks"
    "winetrics"
    "winegui"

    # drivers
    "mesa"
    "mesa-32bit"
    "vulkan-loader"
    "vulkan-loader-32bit"
    "libgcc-32bit"
    "libstdc++-32bit"
    "libdrm-32bit"
    "libglvnd-32bit"

    #1}}}

    #{{{1 Emulation

    "qemu"
    "coreutils"
    "qemu-firmware"
    "pciutils"
    "procps-ng"
    "cdrtools"
    "usbutils"
    "util-linux"
    "socat"
    "spicy"
    "swtpm"
    "zsync"

    #1}}}

    #{{{1 Electronics
    # https://help.ubuntu.com/community/UbuntuEngineering

    ## PCB
    "kicad-8.0.6_1"
    "kicad-footprints-8.0.6_1"
    "kicad-library-8.0.6_1"
    "kicad-packages3D-8.0.6_1"
    "kicad-symbols-8.0.6_1"
    "kicad-templates-8.0.6_1"

    ## CAD
    "openscad"
    # "freecad"

    ## Circuit Simulation
    # TODO: circuit simulation and verilog

    #1}}}
)

sudo xbps-install -y "${packages[@]}"
