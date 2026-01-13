#!/usr/bin/env bash
# --------------------------------------------------
# NOTE:
# This file is intended to be SOURCED, not executed.
# Must be compatible with set -Eeuo pipefail.
# --------------------------------------------------

NEOVIM_REPO_URL="https://github.com/neovim/neovim"
NEOVIM_PATH="${HOME}/.base_repos/neovim"

DEPENDENCIES=(
    ninja-build
    gettext
    libtool
    libtool-bin
    autoconf
    automake
    cmake
    g++
    pkg-config
    unzip
    curl
    doxygen
)

# --------------------------------------------------
# Dependencies
# --------------------------------------------------
sudo apt-get install --yes "${DEPENDENCIES[@]}" >/dev/null 2>&1

# --------------------------------------------------
# Repository
# --------------------------------------------------
if [[ ! -d "${NEOVIM_PATH}" ]]; then
    git clone --depth 1 "${NEOVIM_REPO_URL}" "${NEOVIM_PATH}" >/dev/null 2>&1
fi

# --------------------------------------------------
# Build & install
# --------------------------------------------------
(
    cd "${NEOVIM_PATH}" || exit 1

    sudo make clean >/dev/null 2>&1 || true
    sudo rm -rf .deps build >/dev/null 2>&1 || true

    git add . >/dev/null 2>&1 || true
    git reset --hard >/dev/null 2>&1
    git pull --ff-only >/dev/null 2>&1

    make CMAKE_BUILD_TYPE=RelWithDebInfo >/dev/null 2>&1
    sudo make install >/dev/null 2>&1
    sudo make clean >/dev/null 2>&1
)

# --------------------------------------------------
# Verify installation
# --------------------------------------------------
nvim --version >/dev/null 2>&1 || true

unset NEOVIM_REPO_URL NEOVIM_PATH DEPENDENCIES
