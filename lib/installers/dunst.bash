#!/usr/bin/env bash

# Dunst installer

set -Eeuo pipefail

source "${HOME}/environment/lib/helpers.bash"

require_commands git make sudo

declare -r DUNST_REPO_URL="https://github.com/dunst-project/dunst.git"
declare -r DUNST_DIR="${HOME}/.base_repos/dunst"

declare -ra DEPENDENCIES=(
    libdbus-1-dev
    libx11-dev
    libxinerama-dev
    libxrandr-dev
    libxss-dev
    libglib2.0-dev
    libpango1.0-dev
    libgtk-3-dev
    libxdg-basedir-dev
    libnotify-dev
)

function main {
    log "Installing dunst dependencies"
    sudo apt install --yes "${DEPENDENCIES[@]}" >/dev/null

    git_clone_pull_repo "${DUNST_REPO_URL}" "${DUNST_DIR}" true

    make_build_install "${DUNST_DIR}"
}

main "$@"
