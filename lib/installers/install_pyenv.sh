#!/usr/bin/env bash

function install_pyenv() {
    rm -rf "${HOME}/.pyenv"
    curl -sSL https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | /usr/bin/env bash
}

install_pyenv
