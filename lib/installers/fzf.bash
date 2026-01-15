#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/helpers.bash"

readonly FZF_REPO_URL="https://github.com/junegunn/fzf.git"
readonly FZF_DIR="${HOME}/.base_repos/fzf"

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
