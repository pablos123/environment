#!/usr/bin/env bash
#
#

export PATH="${PATH}:${HOME}/environment/bin:${HOME}/.local/bin"

upgrade_system

install_neovim

rm -rf "${HOME}/.config/i3" "${HOME}/.bashrc" "${HOME}/.profile"

rm -rf "${HOME}/.wallpapers"
mkdir -p "${HOME}/.wallpapers"
git clone "git@github.com:pablos123/.wallpapers.git" "${HOME}/.wallpapers"

install_fonts
reload_environment

