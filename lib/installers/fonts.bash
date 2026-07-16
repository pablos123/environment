#!/usr/bin/env bash

# Nerd Fonts installer

set -Eeuo pipefail

source "${HOME}/environment/lib/helpers.bash"

require_commands curl tar fc-cache

declare -ra FONTS=(
    SourceCodePro
    JetBrainsMono
    Lilex
    Iosevka
    ZedMono
)

declare -r FONTS_DIR="${HOME}/.local/share/fonts"
declare -r NERD_FONTS_BASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"
declare -r VERSION_FILE="${FONTS_DIR}/.nerd-fonts-version"

function main {
    local force
    force="$(parse_force_flag "${1:-}")"

    mkdir --parents "${FONTS_DIR}"

    local latest
    latest="$(github_latest_release_tag "ryanoasis/nerd-fonts")"

    if [[ "${force}" == "false" && -n "${latest}" && -f "${VERSION_FILE}" ]] \
        && [[ "$(<"${VERSION_FILE}")" == "${latest}" ]]; then
        log "Nerd fonts ${latest} already installed, skipping (use --force to reinstall)"
        return 0
    fi

    local font
    for font in "${FONTS[@]}"; do
        log "Installing ${font} Nerd font"
        local font_dir="${FONTS_DIR}/${font}Nerd"
        local archive_path="${FONTS_DIR}/${font}Nerd.tar.xz"

        rm --recursive --force "${font_dir}"
        mkdir --parents "${font_dir}"

        curl --fail --no-progress-meter --location \
            "${NERD_FONTS_BASE_URL}/${font}.tar.xz" \
            --output "${archive_path}"

        tar --extract --file "${archive_path}" --directory "${font_dir}"
        rm --force "${archive_path}"
    done

    log "Refreshing font cache"
    fc-cache --really-force >/dev/null

    if [[ -n "${latest}" ]]; then
        echo "${latest}" >"${VERSION_FILE}"
    fi
}

main "$@"
