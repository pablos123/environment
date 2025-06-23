#!/usr/bin/env bash

function install_nvm() {
    local nvm_version
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    source "$HOME/.nvm/nvm.sh"
    nvm_version="$(nvm ls-remote | grep 'Latest LTS:' | tail -1 | awk '{print $2}' | sed 's/\..*//' | tr -d v)"
    nvm install "${nvm_version}"
}

install_nvm
