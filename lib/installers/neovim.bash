#!/usr/bin/env bash
set -Eeuo pipefail

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
sudo apt-get install --yes "${DEPENDENCIES[@]}" &>/dev/null

# --------------------------------------------------
# Repository
# --------------------------------------------------
if [[ ! -d "${NEOVIM_PATH}" ]]; then
    git clone --depth 1 "${NEOVIM_REPO_URL}" "${NEOVIM_PATH}" &>/dev/null
fi

# --------------------------------------------------
# Build & install
# --------------------------------------------------
(
    cd -- "${NEOVIM_PATH}" || exit 1

    sudo make clean &>/dev/null || true
    sudo rm --recursive --force -- .deps build &>/dev/null || true

    git add . &>/dev/null || true
    git reset --hard &>/dev/null
    git pull --ff-only &>/dev/null

    make CMAKE_BUILD_TYPE=RelWithDebInfo &>/dev/null
    sudo make install &>/dev/null
    sudo make clean &>/dev/null
)

# --------------------------------------------------
# Verify installation
# --------------------------------------------------
nvim --version

unset NEOVIM_REPO_URL NEOVIM_PATH DEPENDENCIES
