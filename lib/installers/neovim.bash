#!/usr/bin/env bash

# Neovim installer

set -Eeuo pipefail

source "${HOME}/environment/lib/helpers.bash"

require_commands git make sudo

declare -r NEOVIM_REPO_URL="https://github.com/neovim/neovim"
declare -r NEOVIM_PATH="${HOME}/.base_repos/neovim"

declare -ra DEPENDENCIES=(
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

function main {
    log "Installing Neovim dependencies"
    sudo apt install --yes "${DEPENDENCIES[@]}" >/dev/null

    git_clone_pull_repo "${NEOVIM_REPO_URL}" "${NEOVIM_PATH}" true

    log "Cleaning build artifacts"
    cd "${NEOVIM_PATH}"
    if ! sudo rm --recursive --force .deps build 2>/dev/null; then
        :
    fi

    make_build_install "${NEOVIM_PATH}" "CMAKE_BUILD_TYPE=RelWithDebInfo"

    log "Verifying Neovim installation"
    if ! command -v nvim >/dev/null; then
        die "nvim not found after installation"
    fi
}

main "$@"
