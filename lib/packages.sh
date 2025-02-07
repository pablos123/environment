#!/usr/bin/env bash
#
# DOCS
# https://github.com/muesli/duf
# https://github.com/sharkdp/hyperfine
# https://github.com/stedolan/jq
# https://github.com/BurntSushi/ripgrep
# https://github.com/sharkdp/bat
# https://github.com/eza-community/eza
# https://github.com/sharkdp/fd

apt_packages=(
    xorg
    pipewire-audio
    pavucontrol
    network-manager
    network-manager-applet
    blueman
    i3
    vim
    duf
    jq
    git
    bat
    tree
    stow
    at
    fd-find
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
    tmux
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
    unrar
    7zip
    tar
    flameshot
    zbar-tools
    scrot
    hsetroot
    nemo
    cowsay
    lolcat
    calendar
    fortune-mod
    espeak
    wmctrl
    xdotool
    xclip
    xsel
    xterm
    x11-xserver-utils
    xdg-utils
    inotify-tools
    libnotify-bin
    python3-venv
    golang
    luarocks
    cpanminus
    yad
    keepassxc
)

cargo_packages=(
    eza
)
