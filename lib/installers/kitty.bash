#!/usr/bin/env bash

# Kitty terminal installer

set -Eeuo pipefail

source "${HOME}/environment/lib/helpers.bash"

require_commands curl ln sh

declare -r KITTY_APP="${HOME}/.local/kitty.app"

function main {
    local force
    force="$(parse_force_flag "${1:-}")"

    if [[ "${force}" == "false" && -x "${KITTY_APP}/bin/kitty" ]]; then
        local installed latest
        installed="$("${KITTY_APP}/bin/kitty" --version | awk '{print $2}')"
        latest="$(github_latest_release_tag "kovidgoyal/kitty")"
        if [[ -n "${latest}" && "v${installed}" == "${latest}" ]]; then
            log "Kitty ${installed} already at latest version, skipping (use --force to reinstall)"
            return 0
        fi
    fi

    log "Installing Kitty terminal"
    curl --fail --no-progress-meter --location https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n 2>/dev/null

    log "Creating Kitty symlinks"
    if ! ln --symbolic --force "${KITTY_APP}/bin/kitty" "${HOME}/bin/kitty"; then
        :
    fi
    if ! ln --symbolic --force "${KITTY_APP}/bin/kitten" "${HOME}/bin/kitten"; then
        :
    fi
}

main "$@"
