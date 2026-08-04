#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

source "${HOME}/environment/lib/helpers.bash"

require_commands curl chmod mv rm

declare -r ZEN_NOTES_DIR="${HOME}/bin"
declare -r ZEN_NOTES_PATH="${ZEN_NOTES_DIR}/zen-notes"
declare -r ZEN_NOTES_DOWNLOAD_PATH="${ZEN_NOTES_DIR}/.zen-notes.download"
declare -r VERSION_FILE="${ZEN_NOTES_DIR}/.zen-notes-version"
declare -r ZEN_NOTES_URL="https://zennotes.org/download/linux-appimage"
declare -r ZEN_NOTES_REPO="ZenNotes/zennotes"

function cleanup {
    rm --force "${ZEN_NOTES_DOWNLOAD_PATH}"
}

function main {
    local force
    force="$(parse_force_flag "${1:-}")"

    log "Checking Zen Notes version"

    local latest
    latest="$(github_latest_release_tag "${ZEN_NOTES_REPO}")"
    latest="${latest#v}"

    if [[ -z "${latest}" ]]; then
        warn "Could not determine latest Zen Notes version, skipping"
        return 0
    fi

    local current=""
    if [[ -f "${VERSION_FILE}" ]]; then
        current="$(<"${VERSION_FILE}")"
    fi

    if [[ "${force}" == "false" && -x "${ZEN_NOTES_PATH}" && "${latest}" == "${current}" ]]; then
        log "Zen Notes v${current} already at latest version, skipping (use --force to reinstall)"
        return 0
    fi

    log "Installing Zen Notes v${latest}"
    curl --fail --no-progress-meter --location \
        --output "${ZEN_NOTES_DOWNLOAD_PATH}" \
        "${ZEN_NOTES_URL}"

    log "Verifying Zen Notes installation"
    [[ -s "${ZEN_NOTES_DOWNLOAD_PATH}" ]] || die "zen-notes not found after installation"

    chmod +x "${ZEN_NOTES_DOWNLOAD_PATH}"
    mv --force "${ZEN_NOTES_DOWNLOAD_PATH}" "${ZEN_NOTES_PATH}"
    echo "${latest}" >"${VERSION_FILE}"

    # Earlier installs kept the version in the filename (zen-notes-v2.20.2).
    rm --force "${ZEN_NOTES_DIR}"/zen-notes-v*
}

main "$@"
