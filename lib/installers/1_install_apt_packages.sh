#!/usr/bin/env bash

function install_apt_packages() {
    local apt_packages
    apt_packages=(
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

        papirus-icon-theme
        fonts-noto-color-emoji
    )
    sudo apt-get update
    sudo apt-get dist-upgrade --yes
    sudo apt-get install --yes "${apt_packages[@]}"

    ln -fs "$(command -v fdfind)" "${HOME}/.local/bin/fd"
}

install_apt_packages

