#!/usr/bin/env bash

# Hardcode-Tray installer

set -Eeuo pipefail

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

function main {
    local force
    force="$(parse_force_flag "${1:-}")"

    git_clone_pull_repo "${HARDCODE_TRAY_REPO_URL}" "${HARDCODE_TRAY_DIR}" true

    # shellcheck disable=SC2154  # set by git_clone_pull_repo above
    if [[ "${force}" == "false" && "${GIT_REPO_CHANGED}" == "false" ]] && command -v hardcode-tray >/dev/null; then
        log "Hardcode-Tray already at latest version, skipping build (use --force to rebuild)"
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

    if command -v hardcode-tray >/dev/null; then
        log "Applying Papirus tray icon fix"
        sudo hardcode-tray --apply --size 16 --theme Papirus
        sudo hardcode-tray --apply --size 22 --theme Papirus
        sudo hardcode-tray --apply --size 24 --theme Papirus

        sudo hardcode-tray --apply --size 16 --theme Papirus-Dark
        sudo hardcode-tray --apply --size 22 --theme Papirus-Dark
        sudo hardcode-tray --apply --size 24 --theme Papirus-Dark

        sudo hardcode-tray --apply --size 16 --theme Papirus-Light
        sudo hardcode-tray --apply --size 22 --theme Papirus-Light
        sudo hardcode-tray --apply --size 24 --theme Papirus-Light
    fi
}

main "$@"
