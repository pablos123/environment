#!/usr/bin/env bash
set -Eeuo pipefail

# Install nvm in /opt/nvm. And link node and npm to use it for all users
# you will not be able to use npm install for global packages because
# the nvm folder is owned by root. Works for some use cases of mine.

readonly NVM_DIR="/opt/nvm"

# --------------------------------------------------
# Cleanup
# --------------------------------------------------
cleanup() {
    unset NVM_DIR node_version
}
trap cleanup EXIT

# --------------------------------------------------
# Create NVM directory
# --------------------------------------------------
sudo mkdir --parents "${NVM_DIR}"

# --------------------------------------------------
# Install NVM
# --------------------------------------------------
echo "==> Installing NVM"
export NVM_DIR="${NVM_DIR}"

curl --fail --silent --show-error -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# --------------------------------------------------
# Source NVM and install Node LTS
# --------------------------------------------------
source "${NVM_DIR}/nvm.sh" || exit 1

nvm install --lts

sleep 0.5

node_version="$(node --version)"
echo "==> Installed Node ${node_version}"

# Create symlinks for node and npm
sudo ln --symbolic --force "${NVM_DIR}/versions/node/${node_version}/bin/node" /usr/bin/node || true
sudo ln --symbolic --force "${NVM_DIR}/versions/node/${node_version}/bin/npm" /usr/bin/npm || true
