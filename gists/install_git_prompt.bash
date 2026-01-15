#!/usr/bin/env bash
set -Eeuo pipefail

readonly GIT_PROMPT_URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"
readonly GIT_PROMPT_PATH="${HOME}/.git-prompt.sh"

# --------------------------------------------------
# Install git-prompt.sh
# --------------------------------------------------
echo "==> Installing git-prompt.sh"

curl --fail --no-progress-meter --location \
    "${GIT_PROMPT_URL}" \
    --output "${GIT_PROMPT_PATH}"
