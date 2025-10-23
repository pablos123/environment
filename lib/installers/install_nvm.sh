#!/usr/bin/env bash

function install_nvm() {
    local node_version

    export NVM_DIR=/opt/nvm

    mkdir -p "${NVM_DIR}"

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

    source "${NVM_DIR}/nvm.sh"

    nvm install --lts

    sleep 0.5

    node_version="$(node --version)"
    ln -sf "${NVM_DIR}/versions/node/${node_version}/bin/node" /usr/bin/node
    ln -sf "${NVM_DIR}/versions/node/${node_version}/bin/npm" /usr/bin/npm
}

sudo bash -c -- "$(declare -f install_nvm); install_nvm"
