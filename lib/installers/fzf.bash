#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/print_functions.bash"
source "${HOME}/environment/lib/trap_handlers.bash"
source "${HOME}/environment/lib/git_helpers.bash"

FZF_REPO_URL="https://github.com/junegunn/fzf.git"
FZF_DIR="${HOME}/.base_repos/fzf"

# --------------------------------------------------
# Clone or update repository
# --------------------------------------------------
clone_or_update_repo "${FZF_REPO_URL}" "${FZF_DIR}"

# --------------------------------------------------
# Install fzf
# --------------------------------------------------
cd "${FZF_DIR}" || exit 1

log "Installing fzf"
./install --all >/dev/null
