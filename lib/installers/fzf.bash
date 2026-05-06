#!/usr/bin/env bash

# fzf installer

set -Eeuo pipefail

source "${HOME}/environment/lib/helpers.bash"

require_commands git

declare -r FZF_REPO_URL="https://github.com/junegunn/fzf.git"
declare -r FZF_DIR="${HOME}/.base_repos/fzf"

function main {
    git_clone_pull_repo "${FZF_REPO_URL}" "${FZF_DIR}" true

    log "Installing fzf"
    "${FZF_DIR}/install" --all >/dev/null
}

main "$@"
