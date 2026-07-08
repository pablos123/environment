#!/usr/bin/env bash

# Zen Notes installer

set -Eeuo pipefail

source "${HOME}/environment/lib/helpers.bash"

require_commands curl find grep chmod

declare -r ZEN_NOTES_PATH="${HOME}/bin"
declare -r ZEN_NOTES_URL="https://zennotes.org/download/linux-appimage"

function main {
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

    # The download URL redirects to a versioned GitHub release asset; resolve
    # the redirect chain with a HEAD request and read the version from it.
    local headers
    headers="$(curl --fail --no-progress-meter --head --location "${ZEN_NOTES_URL}")"

    local latest_version=""
    if match="$(grep --only-matching -iE 'ZenNotes-[0-9]+\.[0-9]+\.[0-9]+' <<<"${headers}" | head --lines=1)"; then
        latest_version="${match#ZenNotes-}"
    fi

    if [[ -n "${latest_version}" && "${latest_version}" != "${current_version}" ]]; then
        log "Updating Zen Notes to v${latest_version}"
        local current_version_path="${ZEN_NOTES_PATH}/zen-notes-v${current_version}"
        local latest_version_path="${ZEN_NOTES_PATH}/zen-notes-v${latest_version}"
        if ! curl --no-progress-meter --location --output "${latest_version_path}" "${ZEN_NOTES_URL}"; then
            :
        fi

        if [[ -s "${latest_version_path}" ]]; then
            if ! chmod +x "${latest_version_path}"; then
                :
            fi

            if [[ -s "${current_version_path}" ]]; then
                if ! rm --force "${current_version_path}"; then
                    :
                fi
            fi
        fi
    fi
}

main "$@"
