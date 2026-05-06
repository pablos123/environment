#!/usr/bin/env bash

# pyenv installer

set -Eeuo pipefail

source "${HOME}/environment/lib/helpers.bash"

require_commands curl bash

function main {
    log "Removing existing pyenv installation"
    if ! rm --recursive --force "${HOME}/.pyenv"; then
        :
    fi

    log "Installing pyenv"
    curl --fail --no-progress-meter --location https://pyenv.run | bash >/dev/null 2>&1
}

main "$@"
