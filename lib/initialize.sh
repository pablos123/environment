#!/usr/bin/env bash

export PATH="${PATH}:${HOME}/environment/bin:${HOME}/.local/bin"

function remove_conflicting_pkgs() {
    sudo apt-get remove --purge -y steam wine rustc cargo
    sudo apt-get autoremove --purge -y
}

function install_rustup() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

remove_conflicting_pkgs

install_rustup

upgrade_system

install_neovim

rm -rf "${HOME}/.config/i3" "${HOME}/.bashrc" "${HOME}/.profile"

rm -rf "${HOME}/.wallpapers"
mkdir -p "${HOME}/.wallpapers"
git clone "git@github.com:pablos123/.wallpapers.git" "${HOME}/.wallpapers"

install_fonts
reload_environment

