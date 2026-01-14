#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/print_functions.bash"
source "${HOME}/environment/lib/trap_handlers.bash"

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
# Cleanup
# --------------------------------------------------
function cleanup() {
    unset DUNST_REPO_URL DUNST_DIR DEPENDENCIES
}

# --------------------------------------------------
# Dependencies
# --------------------------------------------------
sudo apt install --yes "${DEPENDENCIES[@]}" >/dev/null

# --------------------------------------------------
# Repository
# --------------------------------------------------
if [[ ! -d "${DUNST_DIR}" ]]; then
    log "Cloning Dunst repository"
    git clone --depth 1 "${DUNST_REPO_URL}" "${DUNST_DIR}" >/dev/null
fi

# --------------------------------------------------
# Build & install
# --------------------------------------------------
cd "${DUNST_DIR}" || exit 1

log "Building Dunst from source"
{
    sudo make clean || true

    git reset --hard
    git pull --ff-only

    make
    sudo make install
    sudo make clean
} >/dev/null
