#!/usr/bin/env bash

function install_rustup() {
    sudo apt-get purge --yes rustc cargo
    sudo apt-get autoremove --purge --yes
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup_installer.sh
    sh /tmp/rustup_installer.sh -y
    source "${HOME}/.cargo/env"
    rustup update
}

# Nothing for now. I'm not using rust
# install_rustup
