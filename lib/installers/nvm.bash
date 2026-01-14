#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/print_functions.bash"
source "${HOME}/environment/lib/trap_handlers.bash"

NVM_DIR="/opt/nvm"

# --------------------------------------------------
# Cleanup
# --------------------------------------------------
function cleanup() {
    unset NVM_DIR node_version
}

# --------------------------------------------------
# Create NVM directory
# --------------------------------------------------
sudo mkdir --parents "${NVM_DIR}" >/dev/null

# --------------------------------------------------
# Install NVM
# --------------------------------------------------
log "Installing NVM"
export NVM_DIR="${NVM_DIR}"

curl --fail --silent --show-error -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash &>/dev/null

# --------------------------------------------------
# Source NVM and install Node LTS
# --------------------------------------------------
source "${NVM_DIR}/nvm.sh" || exit 1

nvm install --lts &>/dev/null

sleep 0.5

node_version="$(node --version)"
log "Installed Node ${node_version}"

# Create symlinks for node and npm
sudo ln --symbolic --force "${NVM_DIR}/versions/node/${node_version}/bin/node" /usr/bin/node || true
sudo ln --symbolic --force "${NVM_DIR}/versions/node/${node_version}/bin/npm" /usr/bin/npm || true
