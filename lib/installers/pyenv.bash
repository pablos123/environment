#!/usr/bin/env bash
# --------------------------------------------------
# NOTE:
# This file is intended to be SOURCED, not executed.
# Must be compatible with set -Eeuo pipefail.
# --------------------------------------------------

# --------------------------------------------------
# Remove existing pyenv installation
# --------------------------------------------------
rm -rf "${HOME}/.pyenv" || true

# --------------------------------------------------
# Install pyenv
# --------------------------------------------------
curl --fail --silent --location https://pyenv.run | bash >/dev/null 2>&1
