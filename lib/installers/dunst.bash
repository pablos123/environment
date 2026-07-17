#!/usr/bin/env bash

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
    local force
    force="$(parse_force_flag "${1:-}")"

    git_clone_pull_repo "${DUNST_REPO_URL}" "${DUNST_DIR}" true

    # shellcheck disable=SC2154  # set by git_clone_pull_repo above
    if [[ "${force}" == "false" && "${GIT_REPO_CHANGED}" == "false" ]] && command -v dunst >/dev/null; then
        log "dunst already at latest version, skipping build (use --force to rebuild)"
        return 0
    fi

    log "Installing dunst dependencies"
    sudo apt install --yes "${DEPENDENCIES[@]}" >/dev/null

    make_build_install "${DUNST_DIR}"
}

main "$@"
