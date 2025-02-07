#!/usr/bin/env bash

source "${HOME}/environment/lib/packages.sh"

set -e -x

original_path="$(pwd)"

function cwd_on_exit() {
    cd "${original_path}"
    echo "Done! Remember to reboot your pc!"
}

trap cwd_on_exit EXIT ERR SIGINT SIGTERM SIGKILL

repos_path="${HOME}/repos"
mkdir -p "${repos_path}" "${HOME}/screenshots" "${HOME}/projects" "${HOME}/bin"

function install_cargo() {
    sudo apt purge -y rustc cargo
    sudo apt autopurge -y
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup_installer.sh
    sh /tmp/rustup_installer.sh -y
    source "${HOME}/.cargo/env"
    rustup update
    cargo install --locked "${cargo_packages[@]}"
}

function install_pyenv() {
    rm -rf "${HOME}/.pyenv"
    curl https://pyenv.run | bash
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

    git add .
    git reset --hard
    git pull

    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    make clean

    nvim --version
}

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

    sudo apt install -y "${dependencies[@]}"

    dunst_path="${repos_path}/dunst"

    [[ ! -d "${dunst_path}" ]] && \
        git clone https://github.com/dunst-project/dunst.git "${dunst_path}"

    cd "${dunst_path}"

    git add .
    git reset --hard
    git pull

    make
    sudo make install
    make clean
}

function install_fzf() {
    local fzf_path

    fzf_path="${repos_path}/fzf"

    [[ ! -d "${fzf_path}" ]] && \
        git clone --depth 1 https://github.com/junegunn/fzf.git "${fzf_path}"

    cd "${fzf_path}"

    git add .
    git reset --hard
    git pull

    (yes | ./install) >/dev/null 2>&1
}

function install_chrome() {
    curl -fsSL 'https://dl-ssl.google.com/linux/linux_signing_key.pub' | sudo gpg --yes --dearmor -o /usr/share/keyrings/google-chrome.gpg
    (echo 'deb [signed-by=/usr/share/keyrings/google-chrome.gpg arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list) > /dev/null
    sudo apt update
    sudo apt install -y google-chrome-stable
    xdg-settings set default-web-browser 'google-chrome.desktop'
}

function install_wezterm() {
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    (echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list) > /dev/null
    sudo apt update
    sudo apt install -y wezterm
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
}

function install_apt() {
    sudo apt update
    sudo apt full-upgrade
    sudo apt install -y "${apt_packages[@]}"
}

function install_pip() {
    pip install --upgrade pip
    sudo apt install -y pipx
    pipx upgrade-all
}

function make_symbolic_links() {
    ln -fs "$(command -v fdfind)" "${HOME}/.local/bin/fd"
}

function cleanup() {
    sudo apt-get autoremove --purge -y
}

install_apt

install_cargo

install_pyenv

install_neovim

install_dunst

install_fzf

install_chrome

install_wezterm

install_fonts

cleanup

reload_environment
