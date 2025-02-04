#!/usr/bin/env bash

original_path="$(pwd)"

repos_path="${HOME}/repos"
mkdir -p "${repos_path}"

function install_rustup() {
    sudo apt purge -y rustc cargo
    sudo apt autopurge -y
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup_installer.sh
    sh /tmp/rustup_installer.sh -y
}

function install_pyenv() {
    curl https://pyenv.run | bash
}

function install_suckless() {
    local tool tool_path tool_version current_tool_version repo_tool_version dependencies
    dependencies=(
        make
        build-essential
        libx11-dev
        libxinerama-dev
        libxft-dev
    )
    sudo apt install -y "${dependencies[@]}"
    for tool in dwm dmenu st; do
        tool_path="${repos_path}/${tool}"

        [[ ! -d "${tool_path}" ]] && \
            git clone "https://git.suckless.org/${tool}" "${tool_path}"

        cd "${tool_path}"

        git pull

        repo_tool_version=$(grep 'VERSION =' config.mk | sed 's/VERSION = //')
        if which "${tool}" >/dev/null; then
            current_tool_version="$("${tool}" -v 2>&1 | sed "s/${tool}[\- ]//")"
            if [[ "${repo_tool_version}" == "${current_tool_version}" ]]; then
                echo "${tool} is in the last available version."
                continue
            fi
        fi

        make
        sudo make install
        make clean
        git add .
        git reset --hard
    done
}

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

    neovim_path="${repos_path}/neovim"

    [[ ! -d "${neovim_path}" ]] && \
        git clone https://github.com/neovim/neovim "${neovim_path}"

    cd "${neovim_path}"

    git pull
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    make clean
    git add .
    git reset --hard

    nvim --version
}

function install_fonts() {
    local font fonts fonts_path
    fonts=(
        SourceCodePro
        JetBrainsMono
        Lilex
    )

    fonts_path="${HOME}/.local/share/fonts"

    mkdir -p "${fonts_path}"
    for font in "${fonts[@]}"; do
        rm -rf "${fonts_path}/${font}Nerd"
        mkdir -p "${fonts_path}/${font}Nerd"
        wget -O "${fonts_path}/${font}Nerd.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.tar.xz"
        tar -xf "${fonts_path}/${font}Nerd.tar.xz" -C "${fonts_path}/${font}Nerd"
        rm -f "${fonts_path}/${font}Nerd.tar.xz"
    done

    fc-cache -rf
}

install_rustup

install_pyenv

install_suckless

install_neovim

install_fonts

cd "${original_path}"
