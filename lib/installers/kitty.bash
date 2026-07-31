#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

source "${HOME}/environment/lib/helpers.bash"

require_commands curl ln sh

declare -r KITTY_APP="${HOME}/.local/kitty.app"

function main {
    local force
    force="$(parse_force_flag "${1:-}")"

    log "Checking Kitty version"

    local latest
    latest="$(github_latest_release_tag "kovidgoyal/kitty")"

    if [[ -z "${latest}" ]]; then
        warn "Could not determine latest Kitty version, skipping"
        return 0
    fi

    if [[ "${force}" == "false" && -x "${KITTY_APP}/bin/kitty" ]]; then
        local installed
        installed="$("${KITTY_APP}/bin/kitty" --version | awk '{print $2}')"
        if [[ "v${installed}" == "${latest}" ]]; then
            log "Kitty ${latest} already at latest version, skipping (use --force to reinstall)"
            return 0
        fi
    fi

    log "Installing Kitty ${latest}"
    curl --fail --no-progress-meter --location https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n &>/dev/null

    log "Creating Kitty symlinks"
    ln --symbolic --force "${KITTY_APP}/bin/kitty" "${HOME}/bin/kitty" || true
    ln --symbolic --force "${KITTY_APP}/bin/kitten" "${HOME}/bin/kitten" || true

    log "Verifying Kitty installation"
    [[ -x "${KITTY_APP}/bin/kitty" ]] || die "kitty not found after installation"
}

main "$@"
