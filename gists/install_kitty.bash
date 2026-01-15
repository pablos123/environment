#!/usr/bin/env bash
set -Eeuo pipefail

readonly KITTY_APP="${HOME}/.local/kitty.app"

# --------------------------------------------------
# Install Kitty terminal
# --------------------------------------------------
echo "==> Installing Kitty terminal"
curl --fail --no-progress-meter --location https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n

# --------------------------------------------------
# Create symlinks
# --------------------------------------------------
echo "==> Creating Kitty symlinks"
mkdir --parents "${HOME}/bin"
ln --symbolic --force "${KITTY_APP}/bin/kitty" "${HOME}/bin/kitty" || true
ln --symbolic --force "${KITTY_APP}/bin/kitten" "${HOME}/bin/kitten" || true
