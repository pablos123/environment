#!/usr/bin/env bash
set -Eeuo pipefail

KITTY_APP="${HOME}/.local/kitty.app"

# --------------------------------------------------
# Install Kitty terminal
# --------------------------------------------------
curl --fail --silent --show-error --location https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n &>/dev/null

# --------------------------------------------------
# Create symlinks
# --------------------------------------------------
ln --symbolic --force -- "${KITTY_APP}/bin/kitty" "${HOME}/bin/kitty" || true
ln --symbolic --force -- "${KITTY_APP}/bin/kitten" "${HOME}/bin/kitten" || true

unset KITTY_APP
