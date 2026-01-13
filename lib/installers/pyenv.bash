#!/usr/bin/env bash
set -Eeuo pipefail

# --------------------------------------------------
# Remove existing pyenv installation
# --------------------------------------------------
rm --recursive --force -- "${HOME}/.pyenv" || true

# --------------------------------------------------
# Install pyenv
# --------------------------------------------------
curl --fail --silent --location https://pyenv.run | bash &>/dev/null
