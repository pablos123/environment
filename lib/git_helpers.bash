#!/usr/bin/env bash
set -Eeuo pipefail

# Git repository helper functions

# Clone or update a git repository
# Usage: clone_or_update_repo <url> <directory>
function clone_or_update_repo() {
    local repo_url="$1"
    local repo_dir="$2"

    if [[ ! -d "${repo_dir}" ]]; then
        log "Cloning ${repo_url}"
        git clone --depth 1 "${repo_url}" "${repo_dir}" >/dev/null
    else
        log "Updating ${repo_dir}"
        cd "${repo_dir}" || return 1
        git fetch --depth 1 >/dev/null
        git reset --hard origin/HEAD >/dev/null
    fi
}

# Build and install from source using make
# Usage: make_build_install <directory> [make_args]
function make_build_install() {
    local build_dir="$1"
    local make_arg="${2:-}"

    cd "${build_dir}" || return 1

    log "Building $(basename "${build_dir}") from source"
    {
        sudo make clean 2>/dev/null || true
        if [[ -n "${make_arg}" ]]; then
            make "${make_arg}"
        else
            make
        fi
        sudo make install
    } >/dev/null
}
