#!/usr/bin/env bash

function install_pyenv() {
    rm -rf "${HOME}/.pyenv"
    curl -fsSL https://pyenv.run | bash
}

install_pyenv
