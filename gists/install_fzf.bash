#!/usr/bin/env bash
set -Eeuo pipefail

readonly FZF_REPO_URL="https://github.com/junegunn/fzf.git"
readonly FZF_DIR="${HOME}/.base_repos/fzf"

# --------------------------------------------------
# Helper: Clone or update a git repository
# --------------------------------------------------
clone_or_update_repo() {
    local repo_url="$1"
    local repo_dir="$2"

    if [[ ! -d "${repo_dir}" ]]; then
        echo "==> Cloning ${repo_url}"
        git clone --depth 1 "${repo_url}" "${repo_dir}"
    else
        echo "==> Updating ${repo_dir}"
        cd "${repo_dir}" || return 1
        git fetch --depth 1
        git reset --hard origin/HEAD
    fi
}

# --------------------------------------------------
# Clone or update repository
# --------------------------------------------------
clone_or_update_repo "${FZF_REPO_URL}" "${FZF_DIR}"

# --------------------------------------------------
# Install fzf
# --------------------------------------------------
cd "${FZF_DIR}" || exit 1

echo "==> Installing fzf"
./install --all
