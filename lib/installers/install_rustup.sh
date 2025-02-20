#!/usr/bin/env bash

function install_rustup() {
    sudo apt purge -y rustc cargo
    sudo apt autopurge -y
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup_installer.sh
    sh /tmp/rustup_installer.sh -y
    source "${HOME}/.cargo/env"
    rustup update
}

install_rustup
