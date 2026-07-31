#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

source "${HOME}/environment/lib/helpers.bash"

require_commands curl sudo apt

function main {
    local force
    force="$(parse_force_flag "${1:-}")"

    log "Checking Zed version"

    local latest
    latest="$(github_latest_release_tag "zed-industries/zed")"

    if [[ -z "${latest}" ]]; then
        warn "Could not determine latest Zed version, skipping"
        return 0
    fi

    if [[ "${force}" == "false" ]] && command -v zed >/dev/null; then
        local installed
        installed="$(zed --version | awk '{print $2}')"
        if [[ "v${installed}" == "${latest}" ]]; then
            log "Zed ${latest} already at latest version, skipping (use --force to reinstall)"
            return 0
        fi
    fi

    log "Installing Zed dependencies"
    sudo apt install --yes rsync >/dev/null

    log "Installing Zed ${latest}"
    curl --fail --no-progress-meter --location https://zed.dev/install.sh | sh &>/dev/null

    log "Verifying Zed installation"
    command -v zed >/dev/null || die "zed not found after installation"
}

main "$@"
