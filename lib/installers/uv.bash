#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

source "${HOME}/environment/lib/helpers.bash"

require_commands curl sh

declare -r UV_BIN_DIR="${HOME}/.local/bin"
declare -r UV_BIN="${UV_BIN_DIR}/uv"
declare -ra UV_TOOLS=(ruff ty)

function install_uv {
    log "Removing existing uv installation"
    rm --force "${UV_BIN}" "${UV_BIN_DIR}/uvx"

    log "Installing uv"
    curl --fail --no-progress-meter --location https://astral.sh/uv/install.sh |
        UV_NO_MODIFY_PATH=1 sh &>/dev/null

    log "Verifying uv installation"
    [[ -x "${UV_BIN}" ]] || die "uv not found after installation"
}

function main {
    local force
    force="$(parse_force_flag "${1:-}")"

    log "Checking uv installation"

    if [[ "${force}" == "false" && -x "${UV_BIN}" ]]; then
        log "uv already installed, updating (use --force to reinstall)"
        "${UV_BIN}" self update &>/dev/null
    else
        install_uv
    fi

    local tool
    for tool in "${UV_TOOLS[@]}"; do
        log "Installing ${tool}"
        "${UV_BIN}" tool install "${tool}" &>/dev/null
    done

    log "Upgrading uv tools"
    "${UV_BIN}" tool upgrade --all &>/dev/null
}

main "$@"
