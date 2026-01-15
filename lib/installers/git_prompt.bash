#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/print_functions.bash"
source "${HOME}/environment/lib/trap_handlers.bash"

GIT_PROMPT_URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"
GIT_PROMPT_PATH="${HOME}/.git-prompt.sh"

# --------------------------------------------------
# Cleanup
# --------------------------------------------------
function cleanup() {
    unset GIT_PROMPT_URL GIT_PROMPT_PATH
}

# --------------------------------------------------
# Install git-prompt.sh
# --------------------------------------------------
log "Installing git-prompt.sh"

curl --fail --silent --show-error --location \
    "${GIT_PROMPT_URL}" \
    --output "${GIT_PROMPT_PATH}"
