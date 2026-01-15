#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/print_functions.bash"
source "${HOME}/environment/lib/trap_handlers.bash"
source "${HOME}/environment/lib/git_helpers.bash"

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
log "Installing Neovim dependencies"
sudo apt install --yes "${DEPENDENCIES[@]}" >/dev/null

# --------------------------------------------------
# Clone or update repository
# --------------------------------------------------
clone_or_update_repo "${NEOVIM_REPO_URL}" "${NEOVIM_PATH}"

# --------------------------------------------------
# Clean build artifacts
# --------------------------------------------------
log "Cleaning build artifacts"
cd "${NEOVIM_PATH}" || exit 1
sudo rm --recursive --force .deps build 2>/dev/null || true

# --------------------------------------------------
# Build & install
# --------------------------------------------------
make_build_install "${NEOVIM_PATH}" "CMAKE_BUILD_TYPE=RelWithDebInfo"

# --------------------------------------------------
# Verify installation
# --------------------------------------------------
log "Verifying Neovim installation"
command -v nvim || exit 1
