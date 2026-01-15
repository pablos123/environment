#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/helpers.bash"

readonly GIT_PROMPT_URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"
readonly GIT_PROMPT_PATH="${HOME}/.git-prompt.sh"

# --------------------------------------------------
# Install git-prompt.sh
# --------------------------------------------------
log "Installing git-prompt.sh"

curl --fail --no-progress-meter --location \
    "${GIT_PROMPT_URL}" \
    --output "${GIT_PROMPT_PATH}"
