#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/print_functions.bash"
source "${HOME}/environment/lib/trap_handlers.bash"

# --------------------------------------------------
# Cleanup
# --------------------------------------------------
function cleanup() {
    : # No variables to clean
}

# --------------------------------------------------
# Remove existing pyenv installation
# --------------------------------------------------
rm --recursive --force "${HOME}/.pyenv" || true

# --------------------------------------------------
# Install pyenv
# --------------------------------------------------
log "Installing pyenv"
curl --fail --no-progress-meter --location https://pyenv.run | bash &>/dev/null
