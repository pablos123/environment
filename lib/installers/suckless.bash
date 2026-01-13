#!/usr/bin/env bash
# --------------------------------------------------
# NOTE:
# This file is intended to be SOURCED, not executed.
# Must be compatible with set -Eeuo pipefail.
# --------------------------------------------------

SUCKLESS_TOOLS=(st dmenu)

DEPENDENCIES=(
    make
    build-essential
    libx11-dev
    libxinerama-dev
    libxft-dev
)

# --------------------------------------------------
# Dependencies
# --------------------------------------------------
sudo apt-get install --yes "${DEPENDENCIES[@]}" >/dev/null 2>&1

# --------------------------------------------------
# Install each suckless tool
# --------------------------------------------------
for tool in "${SUCKLESS_TOOLS[@]}"; do
    tool_path="${HOME}/.base_repos/${tool}"
    tool_bin="/usr/local/bin/${tool}"
    tool_config="${HOME}/environment/lib/shared/${tool}_config.h"

    # Clone repository if not exists
    if [[ ! -d "${tool_path}" ]]; then
        git clone --depth 1 "https://git.suckless.org/${tool}" "${tool_path}" >/dev/null 2>&1
    fi

    # Build and install
    (
        cd "${tool_path}" || exit 1

        git pull --ff-only >/dev/null 2>&1 || true

        # Get current installed version
        current_tool_version=""
        if command -v "${tool_bin}" >/dev/null 2>&1; then
            current_tool_version=$("${tool_bin}" -v 2>&1 | sed "s@${tool}-@@;s@${tool_bin} @@" || true)
        fi

        # Get repository version
        repo_tool_version=$(grep 'VERSION =' config.mk | sed 's/VERSION = //' || true)

        # Install if version mismatch or not installed
        if [[ "${repo_tool_version}" != "${current_tool_version}" ]]; then
            # Copy custom config if exists
            if [[ -s "${tool_config}" ]]; then
                cp "${tool_config}" ./config.def.h || true
            fi

            make >/dev/null 2>&1
            sudo make install >/dev/null 2>&1
            make clean >/dev/null 2>&1 || true

            git add . >/dev/null 2>&1 || true
            git reset --hard >/dev/null 2>&1 || true
        fi
    )
done

unset SUCKLESS_TOOLS DEPENDENCIES tool tool_path tool_bin tool_config current_tool_version repo_tool_version
