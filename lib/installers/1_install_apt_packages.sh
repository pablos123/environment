#!/usr/bin/env bash

function install_apt_packages() {
    local apt_packages
    apt_packages=(
        xorg
        i3
        pipewire-audio
        pavucontrol
        network-manager
        network-manager-gnome
        dbus-x11
        terminator
        blueman
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
        unrar-free
        7zip
        tar
        flameshot
        zbar-tools
        scrot
        hsetroot
        eza
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
        x11-xserver-utils
        xdg-utils
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
        build-essential
        papirus-icon-theme
        shellcheck
        libreoffice
    )
    sudo apt-get update
    sudo apt-get dist-upgrade --yes
    sudo apt-get install --yes "${apt_packages[@]}"

    ln -fs "$(command -v fdfind)" "${HOME}/.local/bin/fd"
}

install_apt_packages

