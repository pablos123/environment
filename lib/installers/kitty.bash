#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/print_functions.bash"
source "${HOME}/environment/lib/trap_handlers.bash"

readonly KITTY_APP="${HOME}/.local/kitty.app"

# --------------------------------------------------
# Install Kitty terminal
# --------------------------------------------------
log "Installing Kitty terminal"
curl --fail --no-progress-meter --location https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n 2>/dev/null

# --------------------------------------------------
# Create symlinks
# --------------------------------------------------
log "Creating Kitty symlinks"
ln --symbolic --force "${KITTY_APP}/bin/kitty" "${HOME}/bin/kitty" || true
ln --symbolic --force "${KITTY_APP}/bin/kitten" "${HOME}/bin/kitten" || true
