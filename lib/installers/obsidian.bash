#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/print_functions.bash"
source "${HOME}/environment/lib/trap_handlers.bash"

OBSIDIAN_PATH="${HOME}/bin"
current_version=""
latest_version=""

# --------------------------------------------------
# Cleanup
# --------------------------------------------------
function cleanup() {
    unset OBSIDIAN_PATH current_version latest_version current_version_file current_version_path latest_version_path
}

# --------------------------------------------------
# Get current installed version
# --------------------------------------------------
current_version_file=$(find "${OBSIDIAN_PATH}" -name "obsidian_v*" 2>/dev/null | head --lines=1 || true)

if [[ -n "${current_version_file}" ]]; then
    current_version=$(echo "${current_version_file}" | grep --only-matching -E 'v[0-9]+\.[0-9]+\.[0-9]+' | head --lines=1 | sed 's/v//' || true)
fi

# --------------------------------------------------
# Get latest version from GitHub
# --------------------------------------------------
latest_version=$(curl --fail --silent --show-error --location https://github.com/obsidianmd/obsidian-releases/releases/ | grep --only-matching -E 'v[0-9]+\.[0-9]+\.[0-9]+' | head --lines=1 | sed 's/v//' || true)

# --------------------------------------------------
# Download and install if newer version available
# --------------------------------------------------
if [[ -n "${latest_version}" && "${latest_version}" != "${current_version}" ]]; then
    log "Updating Obsidian to v${latest_version}"
    current_version_path="${OBSIDIAN_PATH}/obsidian_v${current_version}"
    latest_version_path="${OBSIDIAN_PATH}/obsidian_v${latest_version}"

    curl --silent --output "${latest_version_path}" "https://github.com/obsidianmd/obsidian-releases/releases/download/v${latest_version}/Obsidian-${latest_version}.AppImage" || true

    if [[ -s "${latest_version_path}" ]]; then
        chmod +x "${latest_version_path}" || true

        if [[ -s "${current_version_path}" ]]; then
            rm --force "${current_version_path}" || true
        fi
    fi
fi
