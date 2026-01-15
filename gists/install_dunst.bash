#!/usr/bin/env bash
set -Eeuo pipefail

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
# Helper: Build and install from source using make
# --------------------------------------------------
make_build_install() {
    local build_dir="$1"
    local make_arg="${2:-}"

    cd "${build_dir}" || return 1

    echo "==> Building $(basename "${build_dir}") from source"
    sudo make clean 2>/dev/null || true
    if [[ -n "${make_arg}" ]]; then
        make "${make_arg}"
    else
        make
    fi
    sudo make install
}

# --------------------------------------------------
# Dependencies
# --------------------------------------------------
echo "==> Installing dunst dependencies"
sudo apt-get install --yes "${DEPENDENCIES[@]}"

# --------------------------------------------------
# Clone or update repository
# --------------------------------------------------
clone_or_update_repo "${DUNST_REPO_URL}" "${DUNST_DIR}"

# --------------------------------------------------
# Build & install
# --------------------------------------------------
make_build_install "${DUNST_DIR}"
