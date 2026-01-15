#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/print_functions.bash"
source "${HOME}/environment/lib/trap_handlers.bash"
source "${HOME}/environment/lib/git_helpers.bash"

readonly DUNST_REPO_URL="https://github.com/dunst-project/dunst.git"
readonly DUNST_DIR="${HOME}/.base_repos/dunst"

declare -ra DEPENDENCIES=(
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
log "Installing dunst dependencies"
sudo apt install --yes "${DEPENDENCIES[@]}" >/dev/null

# --------------------------------------------------
# Clone or update repository
# --------------------------------------------------
clone_or_update_repo "${DUNST_REPO_URL}" "${DUNST_DIR}"

# --------------------------------------------------
# Build & install
# --------------------------------------------------
make_build_install "${DUNST_DIR}"
