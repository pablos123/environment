#!/usr/bin/env bash
# --------------------------------------------------
# NOTE:
# This file is intended to be SOURCED, not executed.
# Must be compatible with set -Eeuo pipefail.
# --------------------------------------------------

NVM_DIR="/opt/nvm"
node_version=""

# --------------------------------------------------
# Create NVM directory
# --------------------------------------------------
sudo mkdir --parents "${NVM_DIR}" >/dev/null 2>&1

# --------------------------------------------------
# Install NVM
# --------------------------------------------------
sudo bash -c "$(cat <<'EOF'
export NVM_DIR=/opt/nvm
curl --fail --silent --show-error -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
EOF
)" >/dev/null 2>&1

# --------------------------------------------------
# Source NVM and install Node LTS
# --------------------------------------------------
(
    export NVM_DIR="${NVM_DIR}"
    # shellcheck source=/dev/null
    source "${NVM_DIR}/nvm.sh" || exit 1

    nvm install --lts >/dev/null 2>&1

    sleep 0.5

    node_version="$(node --version)"

    # Create symlinks for node and npm
    sudo ln --symbolic --force "${NVM_DIR}/versions/node/${node_version}/bin/node" /usr/bin/node || true
    sudo ln --symbolic --force "${NVM_DIR}/versions/node/${node_version}/bin/npm" /usr/bin/npm || true
)

unset NVM_DIR node_version
