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

    dunst_path="${REPOS_PATH}/dunst"

    [[ ! -d "${dunst_path}" ]] &&
        git clone https://github.com/dunst-project/dunst.git "${dunst_path}"

    cd "${dunst_path}"

    git add .
    git reset --hard
    git pull

    make
    sudo make install
    make clean
}

install_dunst

