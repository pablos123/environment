#!/usr/bin/env bash

function install_neovim() {
    local dependencies neovim_path

    dependencies=(
        ninja-build
        gettext
        libtool
        libtool-bin
        autoconf
        automake
        cmake
        g++
        pkg-config
        unzip
        curl
        doxygen
    )

    sudo apt install -y "${dependencies[@]}"

    neovim_path="${REPOS_PATH}/neovim"

    [[ ! -d "${neovim_path}" ]] &&
        git clone https://github.com/neovim/neovim "${neovim_path}"

    cd "${neovim_path}"

    git add .
    git reset --hard
    git pull

    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    make clean

    nvim --version
}

install_neovim
