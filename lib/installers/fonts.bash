#!/usr/bin/env bash
# --------------------------------------------------
# NOTE:
# This file is intended to be SOURCED, not executed.
# Must be compatible with set -Eeuo pipefail.
# --------------------------------------------------

FONTS=(
    SourceCodePro
    JetBrainsMono
    Lilex
    Iosevka
    ZedMono
)

FONTS_DIR="${HOME}/.local/share/fonts"
NERD_FONTS_BASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"

# --------------------------------------------------
# Prepare directory
# --------------------------------------------------
mkdir --parents "${FONTS_DIR}"

# --------------------------------------------------
# Install fonts
# --------------------------------------------------
for font in "${FONTS[@]}"; do
    FONT_DIR="${FONTS_DIR}/${font}Nerd"
    ARCHIVE_PATH="${FONTS_DIR}/${font}Nerd.tar.xz"

    rm --recursive --force -- "${FONT_DIR}"
    mkdir --parents "${FONT_DIR}"

    curl --fail --silent --show-error --location \
        "${NERD_FONTS_BASE_URL}/${font}.tar.xz" \
        --output "${ARCHIVE_PATH}"

    tar --extract --file "${ARCHIVE_PATH}" --directory "${FONT_DIR}"
    rm --force -- "${ARCHIVE_PATH}"
done

# --------------------------------------------------
# Refresh font cache
# --------------------------------------------------
fc-cache --really-force >/dev/null

unset FONTS FONTS_DIR NERD_FONTS_BASE_URL FONT_DIR ARCHIVE_PATH
