#!/usr/bin/env bash
set -Eeuo pipefail

NVM_DIR="/opt/nvm"

# --------------------------------------------------
# Create NVM directory
# --------------------------------------------------
sudo mkdir --parents -- "${NVM_DIR}" &>/dev/null

# --------------------------------------------------
# Install NVM
# --------------------------------------------------
sudo bash -c "export NVM_DIR='/opt/nvm'; curl --fail --silent --show-error -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash" &>/dev/null

# --------------------------------------------------
# Source NVM and install Node LTS
# --------------------------------------------------
(
    export NVM_DIR="/opt/nvm"
    # shellcheck source=/dev/null
    source -- "${NVM_DIR}/nvm.sh" || exit 1

    nvm install --lts &>/dev/null

    sleep 0.5

    node_version="$(node --version)"

    # Create symlinks for node and npm
    sudo ln --symbolic --force -- "${NVM_DIR}/versions/node/${node_version}/bin/node" /usr/bin/node || true
    sudo ln --symbolic --force -- "${NVM_DIR}/versions/node/${node_version}/bin/npm" /usr/bin/npm || true
)

# Note: node_version is created in subshell and doesn't leak to parent scope
unset NVM_DIR
