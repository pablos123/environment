#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

source "${HOME}/environment/lib/helpers.bash"

require_commands curl sudo apt dpkg dpkg-query

declare -r MAILSPRING_REPO="Foundry376/Mailspring"

declare MAILSPRING_TMP_DIR=""

function cleanup {
    if [[ -n "${MAILSPRING_TMP_DIR}" && -d "${MAILSPRING_TMP_DIR}" ]]; then
        rm --recursive --force "${MAILSPRING_TMP_DIR}"
    fi
}

function main {
    local force
    force="$(parse_force_flag "${1:-}")"

    local arch
    arch="$(dpkg --print-architecture)"
    case "${arch}" in
        amd64 | arm64) ;;
        *) die "Mailspring has no .deb for architecture: ${arch}" ;;
    esac

    log "Checking Mailspring version"

    local latest
    latest="$(github_latest_release_tag "${MAILSPRING_REPO}")"

    if [[ -z "${latest}" ]]; then
        warn "Could not determine latest Mailspring version, skipping"
        return 0
    fi

    if [[ "${force}" == "false" ]] && command -v mailspring >/dev/null; then
        local installed
        installed="$(dpkg-query --showformat='${Version}' --show mailspring 2>/dev/null || true)"
        if [[ "${installed}" == "${latest}" ]]; then
            log "Mailspring ${latest} already at latest version, skipping (use --force to reinstall)"
            return 0
        fi
    fi

    MAILSPRING_TMP_DIR="$(mktemp --directory)"
    local deb_path="${MAILSPRING_TMP_DIR}/mailspring.deb"
    local deb_url="https://github.com/${MAILSPRING_REPO}/releases/download/${latest}/mailspring-${latest}-${arch}.deb"

    log "Downloading Mailspring ${latest} (${arch})"
    curl --fail --no-progress-meter --location --output "${deb_path}" "${deb_url}"

    log "Installing Mailspring ${latest}"
    sudo apt install --yes "${deb_path}" >/dev/null

    log "Verifying Mailspring installation"
    command -v mailspring >/dev/null || die "mailspring not found after installation"
}

main "$@"
