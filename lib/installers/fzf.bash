#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

source "${HOME}/environment/lib/helpers.bash"

require_commands git

declare -r FZF_REPO_URL="https://github.com/junegunn/fzf.git"
declare -r FZF_DIR="${HOME}/.base_repos/fzf"

function main {
    local force
    force="$(parse_force_flag "${1:-}")"

    git_clone_pull_repo "${FZF_REPO_URL}" "${FZF_DIR}" true

    # shellcheck disable=SC2154  # set by git_clone_pull_repo above
    if [[ "${force}" == "false" && "${GIT_REPO_CHANGED}" == "false" ]] && command -v fzf >/dev/null; then
        log "fzf already at latest version, skipping install (use --force to reinstall)"
        return 0
    fi

    log "Installing fzf"
    "${FZF_DIR}/install" --all >/dev/null
}

main "$@"
