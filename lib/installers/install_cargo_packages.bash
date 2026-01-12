#!/usr/bin/env bash

function install_cargo_packages() {
    local cargo_packages
    cargo_packages=()
    source "${HOME}/.cargo/env"
    cargo install --locked "${cargo_packages[@]}"
}

# install_cargo_packages
