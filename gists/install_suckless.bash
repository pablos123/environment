#!/usr/bin/env bash
set -Eeuo pipefail

declare -ra SUCKLESS_TOOLS=(st dmenu)

declare -ra DEPENDENCIES=(
    make
    build-essential
    libx11-dev
    libxinerama-dev
    libxft-dev
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
echo "==> Installing suckless dependencies"
sudo apt-get install --yes "${DEPENDENCIES[@]}"

# --------------------------------------------------
# Install each suckless tool
# --------------------------------------------------
for tool in "${SUCKLESS_TOOLS[@]}"; do
    tool_path="${HOME}/.base_repos/${tool}"
    tool_url="https://git.suckless.org/${tool}"

    clone_or_update_repo "${tool_url}" "${tool_path}"
    make_build_install "${tool_path}"
done
