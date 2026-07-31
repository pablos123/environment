#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

source "${HOME}/environment/lib/helpers.bash"

require_commands curl

declare -r GIT_PROMPT_URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"
declare -r GIT_PROMPT_PATH="${HOME}/.git-prompt.sh"

function main {
    log "Installing git-prompt"

    curl --fail --no-progress-meter --location \
        "${GIT_PROMPT_URL}" \
        --output "${GIT_PROMPT_PATH}"

    log "Verifying git-prompt installation"
    [[ -s "${GIT_PROMPT_PATH}" ]] || die "git-prompt.sh not found after installation"
}

main "$@"
