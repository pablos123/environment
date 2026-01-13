#!/usr/bin/env bash
# --------------------------------------------------
# NOTE:
# This file is intended to be SOURCED, not executed.
# Must be compatible with set -Eeuo pipefail.
# --------------------------------------------------

HARDCODE_TRAY_REPO_URL="https://github.com/bil-elmoussaoui/Hardcode-Tray"
HARDCODE_TRAY_DIR="${HOME}/.base_repos/Hardcode-Tray"

DEPENDENCIES=(
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

# --------------------------------------------------
# Dependencies
# --------------------------------------------------
sudo apt install --yes "${DEPENDENCIES[@]}" >/dev/null

# --------------------------------------------------
# Repository
# --------------------------------------------------
if [[ ! -d "${HARDCODE_TRAY_DIR}" ]]; then
    git clone --depth 1 "${HARDCODE_TRAY_REPO_URL}" "${HARDCODE_TRAY_DIR}" >/dev/null
fi

# --------------------------------------------------
# Build & install
# --------------------------------------------------
(
    cd "${HARDCODE_TRAY_DIR}" || exit 1

    git reset --hard >/dev/null
    git pull --ff-only >/dev/null

    meson setup \
        --reconfigure \
        --prefix=/usr \
        builddir >/dev/null

    sudo ninja --directory builddir install >/dev/null
)

# --------------------------------------------------
# Theme fix (Papirus)
# --------------------------------------------------
if command -v hardcode-tray >/dev/null 2>&1; then
    sudo --preserve-env=HOME \
        hardcode-tray \
        --apply \
        --conversion-tool RSVGConvert \
        --size 22 \
        --theme Papirus \
        || true
fi

unset HARDCODE_TRAY_REPO_URL HARDCODE_TRAY_DIR DEPENDENCIES
