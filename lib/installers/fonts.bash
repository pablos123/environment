#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/print_functions.bash"
source "${HOME}/environment/lib/trap_handlers.bash"

declare -ra FONTS=(
    SourceCodePro
    JetBrainsMono
    Lilex
    Iosevka
    ZedMono
)

readonly FONTS_DIR="${HOME}/.local/share/fonts"
readonly NERD_FONTS_BASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"

# --------------------------------------------------
# Prepare directory
# --------------------------------------------------
mkdir --parents "${FONTS_DIR}"

# --------------------------------------------------
# Install fonts
# --------------------------------------------------
for FONT in "${FONTS[@]}"; do
    log "Installing ${FONT} Nerd font"
    FONT_DIR="${FONTS_DIR}/${FONT}Nerd"
    ARCHIVE_PATH="${FONTS_DIR}/${FONT}Nerd.tar.xz"

    rm --recursive --force "${FONT_DIR}"
    mkdir --parents "${FONT_DIR}"

    curl --fail --no-progress-meter --location \
        "${NERD_FONTS_BASE_URL}/${FONT}.tar.xz" \
        --output "${ARCHIVE_PATH}"

    tar --extract --file "${ARCHIVE_PATH}" --directory "${FONT_DIR}"
    rm --force "${ARCHIVE_PATH}"
done

# --------------------------------------------------
# Refresh font cache
# --------------------------------------------------
log "Refreshing font cache"
fc-cache --really-force >/dev/null
