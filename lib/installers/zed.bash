#!/usr/bin/env bash

# Zed editor installer

set -Eeuo pipefail

source "${HOME}/environment/lib/helpers.bash"

require_commands curl sudo apt

function main {
    log "Installing Zed dependencies"
    sudo apt install --yes rsync >/dev/null

    log "Installing Zed editor"
    curl --fail --no-progress-meter --location https://zed.dev/install.sh | sh
}

main "$@"
