#!/usr/bin/env bash

function install_apt_packages() {
    local apt_packages
    apt_packages=(
        xorg
        pipewire-audio
        pavucontrol
        network-manager
        network-manager-gnome
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
        xdg-user-dirs
        inotify-tools
        libnotify-bin
        python3-venv
        golang
        luarocks
        cpanminus
        yad
        keepassxc
        picom
        bash-completion
        pipx
        zenity
    )
    sudo apt-get update
    sudo apt-get dist-upgrade --yes
    sudo apt-get install --yes "${apt_packages[@]}"

    ln -fs "$(command -v fdfind)" "${HOME}/.local/bin/fd"
}

install_apt_packages

