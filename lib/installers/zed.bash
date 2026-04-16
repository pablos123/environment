#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/helpers.bash"

# --------------------------------------------------
# Dependencies
# --------------------------------------------------
log "Installing Zed dependencies"
sudo apt install --yes rsync >/dev/null

# --------------------------------------------------
# Install Zed editor
# --------------------------------------------------
log "Installing Zed editor"
curl --fail --no-progress-meter --location https://zed.dev/install.sh | sh
