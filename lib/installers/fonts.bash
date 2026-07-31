#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

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

    log "Checking Nerd fonts version"

    local latest
    latest="$(github_latest_release_tag "ryanoasis/nerd-fonts")"

    if [[ -z "${latest}" ]]; then
        warn "Could not determine latest Nerd fonts version, skipping"
        return 0
    fi

    if [[ "${force}" == "false" && -f "${VERSION_FILE}" &&
        "$(<"${VERSION_FILE}")" == "${latest}" ]]; then
        log "Nerd fonts ${latest} already at latest version, skipping (use --force to reinstall)"
        return 0
    fi

    log "Installing Nerd fonts ${latest}"

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

    echo "${latest}" >"${VERSION_FILE}"
}

main "$@"
