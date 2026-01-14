#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/print_functions.bash"
source "${HOME}/environment/lib/trap_handlers.bash"

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
# Cleanup
# --------------------------------------------------
function cleanup() {
    unset NEOVIM_REPO_URL NEOVIM_PATH DEPENDENCIES
}

# --------------------------------------------------
# Dependencies
# --------------------------------------------------
sudo apt install --yes "${DEPENDENCIES[@]}" >/dev/null

# --------------------------------------------------
# Repository
# --------------------------------------------------
if [[ ! -d "${NEOVIM_PATH}" ]]; then
    log "Cloning Neovim repository"
    git clone --depth 1 "${NEOVIM_REPO_URL}" "${NEOVIM_PATH}" >/dev/null
fi

# --------------------------------------------------
# Build & install
# --------------------------------------------------
cd "${NEOVIM_PATH}" || exit 1

log "Building Neovim from source"
{

    sudo make clean || true
    sudo rm --recursive --force .deps build || true

    git add . >/dev/null || true
    git reset --hard
    git pull --ff-only

    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    sudo make clean
} >/dev/null

# --------------------------------------------------
# Verify installation
# --------------------------------------------------
nvim --version
