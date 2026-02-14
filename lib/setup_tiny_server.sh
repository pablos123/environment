#!/usr/bin/env bash

set -Eeuo pipefail

# --------------------------------------------------
# Configuration (constants only)
# --------------------------------------------------
readonly TARGET_USER="pab"
readonly MOUNT_BASE="/media/${TARGET_USER}"
readonly ORIGINAL_PWD="$(pwd)"

declare -ra SUCKLESS_TOOLS=(st dmenu dwm)
declare -ra APT_PACKAGES=(
    tree 
    htop 
    vim
    git
    sudo
    ntfs-3g
    rfkill
    curl
    keepassxc
    fwupd
    make
    build-essential
    libx11-dev
    libxinerama-dev
    libxft-dev
    xorg
    hsetroot
    sshfs
    zip
    unzip
    unrar-free
    7zip
    tmux
    upower
    xfe
    shellcheck
    pipx
    aria2
)

# --------------------------------------------------
# Helpers (only our messages)
# --------------------------------------------------
function log() {
    printf '\033[1;32m==>\033[0m %s\n' "${1}"
}

function warn() {
    printf '\033[1;33m[WARN]\033[0m %s\n' "${1}"
}

function die() {
    printf '\033[1;31m[ERROR]\033[0m %s\n' "${1}" >&2
    exit 1
}

# --------------------------------------------------
# Cleanup
# --------------------------------------------------
function cleanup() {
	apt autopurge --yes
}

# --------------------------------------------------
# Traps
# --------------------------------------------------
function on_error() {
    local exit_code="${?}"
    cd "${ORIGINAL_PWD}" || true
    printf '\033[1;31m[ERROR]\033[0m Post-install setup failed (exit code %s)\n' "${exit_code}" >&2
    exit "${exit_code}"
}

function on_exit() {
    cd "${ORIGINAL_PWD}" || true
    cleanup
}

trap on_error ERR SIGINT SIGTERM
trap on_exit EXIT

# --------------------------------------------------
# Preconditions
# --------------------------------------------------
function require_root() {
    if [[ "${EUID}" -ne 0 ]]; then
        die "Run this script as root"
    fi
}

require_root

log "Starting Debian headless post-install setup"

# --------------------------------------------------
# APT: Remove cdrom entries
# --------------------------------------------------
log "Removing cdrom entries from APT sources"

sed --in-place '/^deb cdrom:/d' /etc/apt/sources.list || true

if [[ -d /etc/apt/sources.list.d ]]; then
    sed --in-place '/^deb cdrom:/d' /etc/apt/sources.list.d/*.list >/dev/null || true
fi

log "Updating package lists"
apt update >/dev/null

# --------------------------------------------------
# Networking: switch fully to NetworkManager
# --------------------------------------------------
log "Installing NetworkManager"
apt install --yes network-manager >/dev/null

log "Disabling legacy ifupdown networking"
rm --force /etc/network/interfaces

systemctl disable networking.service &>/dev/null || true
systemctl stop networking.service &>/dev/null || true

apt purge --yes ifupdown >/dev/null || true

log "Enabling NetworkManager"
systemctl enable NetworkManager >/dev/null
systemctl restart NetworkManager >/dev/null

# --------------------------------------------------
# Base packages
# --------------------------------------------------
log "Installing base packages"

apt update
apt --yes "${APT_PACKAGES[@]}"

# --------------------------------------------------
# User configuration
# --------------------------------------------------
log "Granting sudo access to ${TARGET_USER}"
usermod --append --groups sudo "${TARGET_USER}" >/dev/null

# --------------------------------------------------
# APT warnings
# --------------------------------------------------
log "Removing apt unstable cli interface warning"
echo "Apt::Cmd::Disable-Script-Warning true;" | tee /etc/apt/apt.conf.d/90disablescriptwarning

# --------------------------------------------------
# Timezone
# --------------------------------------------------
log "Configuring correct timezone"
timedatectl set-timezone America/Argentina/Buenos_Aires

# --------------------------------------------------
# Helper: Clone or update a git repository
# --------------------------------------------------
clone_or_update_repo() {
    local repo_url="$1"
    local repo_dir="$2"

    if [[ ! -d "${repo_dir}" ]]; then
        echo "==> Cloning ${repo_url}"
        git clone --depth 1 "${repo_url}" "${repo_dir}"
    else
        echo "==> Updating ${repo_dir}"
        cd "${repo_dir}" || return 1
        git fetch --depth 1
        git reset --hard origin/HEAD
    fi
}

# --------------------------------------------------
# Helper: Build and install from source using make
# --------------------------------------------------
make_build_install() {
    local build_dir="$1"
    local make_arg="${2:-}"

    cd "${build_dir}" || return 1

    echo "==> Building $(basename "${build_dir}") from source"
    make clean 2>/dev/null || true
    if [[ -n "${make_arg}" ]]; then
        make "${make_arg}"
    else
        make
    fi
    make install
}

# --------------------------------------------------
# Dependencies
# --------------------------------------------------
log "Installing suckless dependencies"

# --------------------------------------------------
# Install each suckless tool
# --------------------------------------------------
for tool in "${SUCKLESS_TOOLS[@]}"; do
    tool_path="/opt/.base_repos/${tool}"
    tool_url="https://git.suckless.org/${tool}"

    clone_or_update_repo "${tool_url}" "${tool_path}"
    make_build_install "${tool_path}"
done

# --------------------------------------------------
# Firmware
# --------------------------------------------------
log "Checking for firmware updates"
fwupdmgr --force --assume-yes refresh
fwupdmgr --force --assume-yes get-updates
fwupdmgr --force --assume-yes update

log "Post-install setup complete"


