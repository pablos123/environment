#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

source "${HOME}/environment/lib/helpers.bash"

require_commands git meson ninja sudo

declare -r HARDCODE_TRAY_REPO_URL="https://github.com/bil-elmoussaoui/Hardcode-Tray"
declare -r HARDCODE_TRAY_DIR="${HOME}/.base_repos/Hardcode-Tray"

declare -ra DEPENDENCIES=(
    build-essential
    meson
    libgirepository1.0-dev
    libgtk-3-dev
    python3
    python3-gi
    gir1.2-rsvg-2.0
    librsvg2-bin
    gir1.2-gtk-3.0
)

declare -ra PAPIRUS_THEMES=(
    Papirus
    Papirus-Dark
    Papirus-Light
)

declare -ra ICON_SIZES=(16 22 24)

function main {
    local force
    force="$(parse_force_flag "${1:-}")"

    log "Checking Hardcode-Tray version"

    git_clone_pull_repo "${HARDCODE_TRAY_REPO_URL}" "${HARDCODE_TRAY_DIR}" true "Hardcode-Tray"

    # shellcheck disable=SC2154  # set by git_clone_pull_repo above
    if [[ "${force}" == "false" && "${GIT_REPO_CHANGED}" == "false" ]] && command -v hardcode-tray >/dev/null; then
        log "Hardcode-Tray already at latest version, skipping (use --force to reinstall)"
    else
        log "Installing Hardcode-Tray dependencies"
        sudo apt install --yes "${DEPENDENCIES[@]}" >/dev/null

        log "Building Hardcode-Tray from source"
        (
            cd "${HARDCODE_TRAY_DIR}"

            meson setup \
                --reconfigure \
                --prefix=/usr \
                builddir >/dev/null

            sudo ninja -C builddir install >/dev/null
        )
    fi

    log "Verifying Hardcode-Tray installation"
    command -v hardcode-tray >/dev/null || die "hardcode-tray not found after installation"

    log "Applying Papirus tray icons"
    local theme
    for theme in "${PAPIRUS_THEMES[@]}"; do
        local -i size
        for size in "${ICON_SIZES[@]}"; do
            sudo hardcode-tray --apply --size "${size}" --theme "${theme}" >/dev/null
        done
    done
}

main "$@"
