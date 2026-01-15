#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/helpers.bash"

declare -ra APT_PACKAGES=(
    xorg
    build-essential
    pipewire-audio
    pulseaudio-utils
    pavucontrol
    network-manager
    network-manager-gnome
    dbus-x11
    bluetooth
    bluez
    bluez-firmware
    firmware-iwlwifi
    blueman
    x11-xserver-utils
    xdg-utils
    i3-wm
    i3lock
    rofi
    polybar
    vim
    duf
    jq
    git
    bat
    tree
    stow
    at
    fd-find
    gpg
    direnv
    ripgrep
    hyperfine
    progress
    htop
    btop
    nvtop
    wavemon
    lsb-release
    upower
    solaar
    ncal
    valgrind
    zathura
    zathura-djvu
    zathura-ps
    zathura-cb
    ffmpeg
    sxiv
    mpv
    imagemagick
    zip
    unzip
    unrar-free
    7zip
    tar
    img2pdf
    flameshot
    zbar-tools
    scrot
    hsetroot
    cowsay
    lolcat
    calendar
    fortune-mod
    espeak
    wmctrl
    xdotool
    xclip
    xsel
    xfe
    pkexec
    inotify-tools
    libnotify-bin
    python3-venv
    luarocks
    yad
    keepassxc
    picom
    bash-completion
    pipx
    curl
    zenity
    shellcheck
    entr
    libreoffice
    pandoc
    meld
    aria2
    redshift
    tmux
    brightnessctl
    inxi
    eza
    gnome-themes-extra
    papirus-icon-theme
    fonts-noto-color-emoji
)

# --------------------------------------------------
# System update
# --------------------------------------------------
log "Updating system packages"
sudo apt update >/dev/null
sudo apt full-upgrade --yes >/dev/null

# --------------------------------------------------
# Package installation
# --------------------------------------------------
log "Installing APT packages"
sudo apt install --yes "${APT_PACKAGES[@]}" >/dev/null

# --------------------------------------------------
# fd compatibility symlink (Debian)
# --------------------------------------------------
if command -v fdfind &>/dev/null; then
    log "Creating fd compatibility symlink"
    mkdir --parents "${HOME}/.local/bin"
    ln --symbolic --force "$(command -v fdfind)" "${HOME}/.local/bin/fd"
fi
