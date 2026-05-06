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

function main {
    local font_dir archive_path

    mkdir --parents "${FONTS_DIR}"

    local font
    for font in "${FONTS[@]}"; do
        log "Installing ${font} Nerd font"
        font_dir="${FONTS_DIR}/${font}Nerd"
        archive_path="${FONTS_DIR}/${font}Nerd.tar.xz"

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
}

main "$@"
