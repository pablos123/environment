#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/helpers.bash"

readonly HARDCODE_TRAY_REPO_URL="https://github.com/bil-elmoussaoui/Hardcode-Tray"
readonly HARDCODE_TRAY_DIR="${HOME}/.base_repos/Hardcode-Tray"

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

# --------------------------------------------------
# Dependencies
# --------------------------------------------------
log "Installing Hardcode-Tray dependencies"
sudo apt install --yes "${DEPENDENCIES[@]}" >/dev/null

# --------------------------------------------------
# Clone or update repository
# --------------------------------------------------
git_clone_pull_repo "${HARDCODE_TRAY_REPO_URL}" "${HARDCODE_TRAY_DIR}" true

# --------------------------------------------------
# Build & install
# --------------------------------------------------
log "Building Hardcode-Tray from source"
(
    cd "${HARDCODE_TRAY_DIR}" || exit 1

    meson setup \
        --reconfigure \
        --prefix=/usr \
        builddir >/dev/null

    sudo ninja -C builddir install >/dev/null
)

# --------------------------------------------------
# Theme fix (Papirus)
# --------------------------------------------------
if command -v hardcode-tray >/dev/null 2>&1; then
    log "Applying Papirus tray icon fix"
    sudo hardcode-tray --apply --size 16 --theme Papirus
    sudo hardcode-tray --apply --size 22 --theme Papirus
    sudo hardcode-tray --apply --size 24 --theme Papirus

    sudo hardcode-tray  --apply --size 16 --theme Papirus-Dark
    sudo hardcode-tray  --apply --size 22 --theme Papirus-Dark
    sudo hardcode-tray  --apply --size 24 --theme Papirus-Dark

    sudo hardcode-tray --apply --size 16 --theme Papirus-Light
    sudo hardcode-tray --apply --size 22 --theme Papirus-Light
    sudo hardcode-tray --apply --size 24 --theme Papirus-Light
fi
