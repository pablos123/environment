#!/usr/bin/env bash
set -Eeuo pipefail

# --------------------------------------------------
# Remove existing pyenv installation
# --------------------------------------------------
echo "==> Removing existing pyenv installation"
rm --recursive --force "${HOME}/.pyenv" || true

# --------------------------------------------------
# Install pyenv
# --------------------------------------------------
echo "==> Installing pyenv"
curl --fail --no-progress-meter --location https://pyenv.run | bash
