#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

source "${HOME}/environment/lib/helpers.bash"

require_commands curl bash

declare -r PYENV_ROOT_DIR="${HOME}/.pyenv"

function main {
    local force
    force="$(parse_force_flag "${1:-}")"

    log "Checking pyenv installation"

    if [[ "${force}" == "false" && -x "${PYENV_ROOT_DIR}/bin/pyenv" &&
        -d "${PYENV_ROOT_DIR}/plugins/pyenv-update" ]]; then
        log "pyenv already installed, updating (use --force to reinstall)"
        "${PYENV_ROOT_DIR}/bin/pyenv" update &>/dev/null
        return 0
    fi

    log "Removing existing pyenv installation"
    rm --recursive --force "${PYENV_ROOT_DIR}" || true

    log "Installing pyenv"
    curl --fail --no-progress-meter --location https://pyenv.run | bash &>/dev/null

    log "Verifying pyenv installation"
    [[ -x "${PYENV_ROOT_DIR}/bin/pyenv" ]] || die "pyenv not found after installation"
}

main "$@"
