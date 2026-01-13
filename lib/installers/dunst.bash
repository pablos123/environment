#!/usr/bin/env bash
set -Eeuo pipefail

DUNST_REPO_URL="https://github.com/dunst-project/dunst.git"
DUNST_DIR="${HOME}/.base_repos/dunst"

DEPENDENCIES=(
    libdbus-1-dev
    libx11-dev
    libxinerama-dev
    libxrandr-dev
    libxss-dev
    libglib2.0-dev
    libpango1.0-dev
    libgtk-3-dev
    libxdg-basedir-dev
    libnotify-dev
)

# --------------------------------------------------
# Dependencies
# --------------------------------------------------
sudo apt install --yes "${DEPENDENCIES[@]}" >/dev/null

# --------------------------------------------------
# Repository
# --------------------------------------------------
if [[ ! -d "${DUNST_DIR}" ]]; then
    git clone --depth 1 "${DUNST_REPO_URL}" "${DUNST_DIR}" >/dev/null
fi

# --------------------------------------------------
# Build & install
# --------------------------------------------------
(
    cd "${DUNST_DIR}" || exit 1

    sudo make clean >/dev/null || true

    git reset --hard >/dev/null
    git pull --ff-only >/dev/null

    make >/dev/null
    sudo make install >/dev/null
    sudo make clean >/dev/null
)

unset DUNST_REPO_URL DUNST_DIR DEPENDENCIES
