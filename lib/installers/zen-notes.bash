#!/usr/bin/env bash

set -Eeuo pipefail

source "${HOME}/environment/lib/helpers.bash"

require_commands curl find grep chmod

declare -r ZEN_NOTES_PATH="${HOME}/bin"
declare -r ZEN_NOTES_URL="https://zennotes.org/download/linux-appimage"
declare -r ZEN_NOTES_REPO="ZenNotes/zennotes"

function main {
    local force
    force="$(parse_force_flag "${1:-}")"

    log "Checking Zen Notes version"

    local current_version_file
    current_version_file="$(find "${ZEN_NOTES_PATH}" -name "zen-notes-v*" 2>/dev/null | head --lines=1)"

    local current_version=""
    local match
    if [[ -n "${current_version_file}" ]]; then
        if match="$(grep --only-matching -E 'v[0-9]+\.[0-9]+\.[0-9]+' <<<"${current_version_file}" | head --lines=1)"; then
            current_version="${match#v}"
        fi
    fi

    local latest_version
    latest_version="$(github_latest_release_tag "${ZEN_NOTES_REPO}")"
    latest_version="${latest_version#v}"

    if [[ -z "${latest_version}" ]]; then
        warn "Could not determine latest Zen Notes version, skipping"
        return 0
    fi

    if [[ "${force}" == "false" && "${latest_version}" == "${current_version}" ]]; then
        log "Zen Notes v${current_version} already at latest version, skipping (use --force to reinstall)"
        return 0
    fi

    log "Updating Zen Notes to v${latest_version}"
    local current_version_path="${ZEN_NOTES_PATH}/zen-notes-v${current_version}"
    local latest_version_path="${ZEN_NOTES_PATH}/zen-notes-v${latest_version}"
    curl --no-progress-meter --location --output "${latest_version_path}" "${ZEN_NOTES_URL}" || true

    if [[ -s "${latest_version_path}" ]]; then
        chmod +x "${latest_version_path}" || true

        if [[ -s "${current_version_path}" && "${current_version_path}" != "${latest_version_path}" ]]; then
            rm --force "${current_version_path}" || true
        fi
    fi
}

main "$@"
