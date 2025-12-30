#!/usr/bin/env bash

function install_kitty() {
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
    ln -sf "${HOME}/.local/kitty.app/bin/kitty" "${HOME}/bin/kitty"
    ln -sf "${HOME}/.local/kitty.app/bin/kitten" "${HOME}/bin/kitten"
}

install_kitty
