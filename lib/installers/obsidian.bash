#!/usr/bin/env bash

# Obsidian installer

set -Eeuo pipefail

source "${HOME}/environment/lib/helpers.bash"

require_commands curl find grep chmod

declare -r OBSIDIAN_PATH="${HOME}/bin"

function main {
    local current_version="" current_version_file latest_version="" match
    local current_version_path latest_version_path releases_html

    log "Checking Obsidian version"
    current_version_file="$(find "${OBSIDIAN_PATH}" -name "obsidian_v*" 2>/dev/null | head --lines=1)"

    if [[ -n "${current_version_file}" ]]; then
        if match="$(grep --only-matching -E 'v[0-9]+\.[0-9]+\.[0-9]+' <<<"${current_version_file}" | head --lines=1)"; then
            current_version="${match#v}"
        fi
    fi

    releases_html="$(curl --fail --no-progress-meter --location https://github.com/obsidianmd/obsidian-releases/releases/)"
    if match="$(grep --only-matching -E 'v[0-9]+\.[0-9]+\.[0-9]+' <<<"${releases_html}" | head --lines=1)"; then
        latest_version="${match#v}"
    fi

    if [[ -n "${latest_version}" && "${latest_version}" != "${current_version}" ]]; then
        log "Updating Obsidian to v${latest_version}"
        current_version_path="${OBSIDIAN_PATH}/obsidian_v${current_version}"
        latest_version_path="${OBSIDIAN_PATH}/obsidian_v${latest_version}"

        if ! curl --no-progress-meter --location --output "${latest_version_path}" \
            "https://github.com/obsidianmd/obsidian-releases/releases/download/v${latest_version}/Obsidian-${latest_version}.AppImage"; then
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
