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
    local force
    force="$(parse_force_flag "${1:-}")"

    git_clone_pull_repo "${NEOVIM_REPO_URL}" "${NEOVIM_PATH}" true

    # shellcheck disable=SC2154  # set by git_clone_pull_repo above
    if [[ "${force}" == "false" && "${GIT_REPO_CHANGED}" == "false" ]] && command -v nvim >/dev/null; then
        log "Neovim already at latest version, skipping build (use --force to rebuild)"
        return 0
    fi

    log "Installing Neovim dependencies"
    sudo apt install --yes "${DEPENDENCIES[@]}" >/dev/null

    log "Cleaning build artifacts"
    cd "${NEOVIM_PATH}"
    sudo rm --recursive --force .deps build 2>/dev/null || true

    make_build_install "${NEOVIM_PATH}" "CMAKE_BUILD_TYPE=RelWithDebInfo"

    log "Verifying Neovim installation"
    command -v nvim >/dev/null || die "nvim not found after installation"
}

main "$@"
