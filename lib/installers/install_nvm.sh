#!/usr/bin/env bash

export NVM_DIR=/opt/nvm

function install_nvm() {
    local node_version

    mkdir -p "${NVM_DIR}"

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

    [[ ! -s "${NVM_DIR}/nvm.sh" ]] || exit 1

    source "${NVM_DIR}/nvm.sh"
    nvm install --lts

    sleep 0.5

    node_version="$(node --version)"
    ln -sf "/opt/nvm/versions/node/${node_version}/bin/node" /usr/bin/node
    ln -sf "/opt/nvm/versions/node/v${node_version}/bin/npm" /usr/bin/npm
}

install_nvm
