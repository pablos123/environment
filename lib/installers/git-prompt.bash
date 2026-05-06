#!/usr/bin/env bash

# git-prompt.sh installer

set -Eeuo pipefail

source "${HOME}/environment/lib/helpers.bash"

require_commands curl

declare -r GIT_PROMPT_URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"
declare -r GIT_PROMPT_PATH="${HOME}/.git-prompt.sh"

function main {
    log "Installing git-prompt.sh"

    curl --fail --no-progress-meter --location \
        "${GIT_PROMPT_URL}" \
        --output "${GIT_PROMPT_PATH}"
}

main "$@"
