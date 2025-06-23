#!/usr/bin/env bash

function install_nvm() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    source "$HOME/.nvm/nvm.sh"
    nvm install --lts
}

install_nvm
