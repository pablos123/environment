#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/print_functions.bash"
source "${HOME}/environment/lib/trap_handlers.bash"

readonly OBSIDIAN_PATH="${HOME}/bin"
CURRENT_VERSION=""

# --------------------------------------------------
# Get current installed version
# --------------------------------------------------
log "Checking Obsidian version"
CURRENT_VERSION_FILE=$(find "${OBSIDIAN_PATH}" -name "obsidian_v*" 2>/dev/null | head --lines=1 || true)

if [[ -n "${CURRENT_VERSION_FILE}" ]]; then
    CURRENT_VERSION=$(echo "${CURRENT_VERSION_FILE}" | grep --only-matching -E 'v[0-9]+\.[0-9]+\.[0-9]+' | head --lines=1 | sed 's/v//' || true)
fi

# --------------------------------------------------
# Get latest version from GitHub
# --------------------------------------------------
LATEST_VERSION=$(curl --fail --no-progress-meter --location https://github.com/obsidianmd/obsidian-releases/releases/ | grep --only-matching -E 'v[0-9]+\.[0-9]+\.[0-9]+' | head --lines=1 | sed 's/v//' || true)

# --------------------------------------------------
# Download and install if newer version available
# --------------------------------------------------
if [[ -n "${LATEST_VERSION}" && "${LATEST_VERSION}" != "${CURRENT_VERSION}" ]]; then
    log "Updating Obsidian to v${LATEST_VERSION}"
    CURRENT_VERSION_PATH="${OBSIDIAN_PATH}/obsidian_v${CURRENT_VERSION}"
    LATEST_VERSION_PATH="${OBSIDIAN_PATH}/obsidian_v${LATEST_VERSION}"

    curl --no-progress-meter --output "${LATEST_VERSION_PATH}" "https://github.com/obsidianmd/obsidian-releases/releases/download/v${LATEST_VERSION}/Obsidian-${LATEST_VERSION}.AppImage" || true

    if [[ -s "${LATEST_VERSION_PATH}" ]]; then
        chmod +x "${LATEST_VERSION_PATH}" || true

        if [[ -s "${CURRENT_VERSION_PATH}" ]]; then
            rm --force "${CURRENT_VERSION_PATH}" || true
        fi
    fi
fi
