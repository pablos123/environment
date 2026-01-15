#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/helpers.bash"

# --------------------------------------------------
# Remove existing pyenv installation
# --------------------------------------------------
log "Removing existing pyenv installation"
rm --recursive --force "${HOME}/.pyenv" || true

# --------------------------------------------------
# Install pyenv
# --------------------------------------------------
log "Installing pyenv"
curl --fail --no-progress-meter --location https://pyenv.run | bash &>/dev/null
