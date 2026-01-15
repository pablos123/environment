#!/usr/bin/env bash
set -Eeuo pipefail

readonly NEOVIM_REPO_URL="https://github.com/neovim/neovim"
readonly NEOVIM_PATH="${HOME}/.base_repos/neovim"

declare -ra DEPENDENCIES=(
    ninja-build
    gettext
    libtool
    libtool-bin
    autoconf
    automake
    cmake
    g++
    pkg-config
    unzip
    curl
    doxygen
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
echo "==> Installing Neovim dependencies"
sudo apt-get install --yes "${DEPENDENCIES[@]}"

# --------------------------------------------------
# Clone or update repository
# --------------------------------------------------
clone_or_update_repo "${NEOVIM_REPO_URL}" "${NEOVIM_PATH}"

# --------------------------------------------------
# Clean build artifacts
# --------------------------------------------------
echo "==> Cleaning build artifacts"
cd "${NEOVIM_PATH}" || exit 1
sudo rm --recursive --force .deps build 2>/dev/null || true

# --------------------------------------------------
# Build & install
# --------------------------------------------------
make_build_install "${NEOVIM_PATH}" "CMAKE_BUILD_TYPE=RelWithDebInfo"

# --------------------------------------------------
# Verify installation
# --------------------------------------------------
echo "==> Verifying Neovim installation"
command -v nvim || exit 1
