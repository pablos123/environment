#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

source "${HOME}/environment/lib/helpers.bash"

require_commands curl sudo apt

function main {
    local force
    force="$(parse_force_flag "${1:-}")"

    if [[ "${force}" == "false" ]] && command -v zed >/dev/null; then
        local installed
        installed="$(zed --version | awk '{print $2}')"
        local latest
        latest="$(github_latest_release_tag "zed-industries/zed")"
        if [[ -n "${latest}" && "v${installed}" == "${latest}" ]]; then
            log "Zed ${installed} already at latest version, skipping (use --force to reinstall)"
            return 0
        fi
    fi

    log "Installing Zed dependencies"
    sudo apt install --yes rsync >/dev/null

    log "Installing Zed editor"
    curl --fail --no-progress-meter --location https://zed.dev/install.sh | sh
}

main "$@"
