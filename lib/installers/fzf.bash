#!/usr/bin/env bash
# --------------------------------------------------
# NOTE:
# This file is intended to be SOURCED, not executed.
# Must be compatible with set -Eeuo pipefail.
# --------------------------------------------------

FZF_REPO_URL="https://github.com/junegunn/fzf.git"
FZF_DIR="${HOME}/.base_repos/fzf"

# --------------------------------------------------
# Repository
# --------------------------------------------------
if [[ ! -d "${FZF_DIR}" ]]; then
    git clone --depth 1 "${FZF_REPO_URL}" "${FZF_DIR}" >/dev/null
fi

# --------------------------------------------------
# Update & install
# --------------------------------------------------
(
    cd "${FZF_DIR}" || exit 1

    git reset --hard >/dev/null
    git pull --ff-only >/dev/null

    ./install --all >/dev/null
)

unset FZF_REPO_URL FZF_DIR
