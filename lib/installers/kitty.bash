#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/print_functions.bash"
source "${HOME}/environment/lib/trap_handlers.bash"

KITTY_APP="${HOME}/.local/kitty.app"

# --------------------------------------------------
# Cleanup
# --------------------------------------------------
function cleanup() {
    unset KITTY_APP
}

# --------------------------------------------------
# Install Kitty terminal
# --------------------------------------------------
log "Installing Kitty terminal"
curl --fail --silent --show-error --location https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n &>/dev/null

# --------------------------------------------------
# Create symlinks
# --------------------------------------------------
ln --symbolic --force "${KITTY_APP}/bin/kitty" "${HOME}/bin/kitty" || true
ln --symbolic --force "${KITTY_APP}/bin/kitten" "${HOME}/bin/kitten" || true
