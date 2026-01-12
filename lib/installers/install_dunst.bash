#!/usr/bin/env bash

function install_dunst() {
    local dependencies dunst_path

    dependencies=(
      libdbus-1-dev
      libx11-dev
      libxinerama-dev
      libxrandr-dev
      libxss-dev
      libglib2.0-dev
      libpango1.0-dev
      libgtk-3-dev
      libxdg-basedir-dev
      libnotify-dev
    )

    sudo apt-get install --yes "${dependencies[@]}"

    dunst_path="${HOME}/.base_repos/dunst"

    [[ ! -d "${dunst_path}" ]] &&
        git clone --depth 1 https://github.com/dunst-project/dunst.git "${dunst_path}"

    (
        cd "${dunst_path}"

        sudo make clean
        git add .
        git reset --hard
        git pull

        make
        sudo make install
        sudo make clean
    )
}

install_dunst

