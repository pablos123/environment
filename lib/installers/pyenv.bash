#!/usr/bin/env bash

# pyenv installer

set -Eeuo pipefail

source "${HOME}/environment/lib/helpers.bash"

require_commands curl bash

declare -r PYENV_ROOT_DIR="${HOME}/.pyenv"

function main {
    local force
    force="$(parse_force_flag "${1:-}")"

    if [[ "${force}" == "false" && -x "${PYENV_ROOT_DIR}/bin/pyenv" &&
        -d "${PYENV_ROOT_DIR}/plugins/pyenv-update" ]]; then
        log "Updating existing pyenv installation (use --force to reinstall)"
        "${PYENV_ROOT_DIR}/bin/pyenv" update >/dev/null 2>&1
        return 0
    fi

    log "Removing existing pyenv installation"
    rm --recursive --force "${PYENV_ROOT_DIR}" || true

    log "Installing pyenv"
    curl --fail --no-progress-meter --location https://pyenv.run | bash >/dev/null 2>&1
}

main "$@"
