#!/usr/bin/env bash

function install_hardcode_tray() {
    local dependencies
    dependencies=(
        build-essential
        meson
        libgirepository1.0-dev
        libgtk-3-dev
        python3
        python3-gi
        gir1.2-rsvg-2.0
        librsvg2-bin
        gir1.2-gtk-3.0
    )
    sudo apt-get install --yes "${dependencies[@]}"

    git clone https://github.com/bil-elmoussaoui/Hardcode-Tray "${HOME}/.base_repos/Hardcode-Tray"

    (
        cd "${HOME}/.base_repos/Hardcode-Tray"
        meson builddir --prefix=/usr
        sudo ninja -C builddir install
    )

    # To fix for papirus run
    # sudo -E hardcode-tray --apply --conversion-tool RSVGConvert --size 22 --theme Papirus
}

# install_hardcode_tray
