#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/print_functions.bash"
source "${HOME}/environment/lib/trap_handlers.bash"

FZF_REPO_URL="https://github.com/junegunn/fzf.git"
FZF_DIR="${HOME}/.base_repos/fzf"

# --------------------------------------------------
# Cleanup
# --------------------------------------------------
function cleanup() {
    unset FZF_REPO_URL FZF_DIR
}

# --------------------------------------------------
# Repository
# --------------------------------------------------
if [[ ! -d "${FZF_DIR}" ]]; then
    log "Cloning fzf repository"
    git clone --depth 1 "${FZF_REPO_URL}" "${FZF_DIR}" >/dev/null
fi

# --------------------------------------------------
# Update & install
# --------------------------------------------------
cd "${FZF_DIR}" || exit 1

{

    git reset --hard
    git pull --ff-only

    ./install --all
} >/dev/null
