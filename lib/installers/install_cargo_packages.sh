#!/usr/bin/env bash

function install_cargo_packages() {
    local cargo_packages
    cargo_packages=()
    source "${HOME}/.cargo/env"
    cargo install --locked "${cargo_packages[@]}"
}

# Nothing for now, eza is now available at official repositories
# install_cargo_packages
