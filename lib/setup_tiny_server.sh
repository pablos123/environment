#!/usr/bin/env bash

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
    pipewire-audio
    firmware-iwlwifi
    curl
    inxi
    python3-venv
    imagemagick
    ripgrep
    bash-completion
    gpg
    stow
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
}

# --------------------------------------------------
# Preconditions
# --------------------------------------------------
function require_root() {
    if [[ "${EUID}" -ne 0 ]]; then
        die "Run this script as root"
    fi
}

require_root

log "Starting Debian headless tiny server post-install setup"

# --------------------------------------------------
# APT: Remove cdrom entries
# --------------------------------------------------
log "Removing cdrom entries from APT sources"

sed --in-place '/^deb cdrom:/d' /etc/apt/sources.list || true

if [[ -d /etc/apt/sources.list.d ]]; then
    sed --in-place '/^deb cdrom:/d' /etc/apt/sources.list.d/*.list || true
fi

log "Updating and upgrading packages"
apt update
apt upgrade --yes
apt autopurge --yes

# --------------------------------------------------
# Base packages
# --------------------------------------------------
log "Installing base packages"

apt install --yes "${APT_PACKAGES[@]}"

# --------------------------------------------------
# Networking: switch fully to NetworkManager
# --------------------------------------------------
log "Installing NetworkManager"
apt install --yes network-manager

log "Disabling legacy ifupdown networking"
rm --force /etc/network/interfaces

systemctl disable networking.service || true
systemctl stop networking.service || true

apt purge --yes ifupdown || true

log "Enabling NetworkManager"
systemctl enable NetworkManager
systemctl restart NetworkManager

# --------------------------------------------------
# User configuration
# --------------------------------------------------
log "Granting sudo access to ${TARGET_USER}"
usermod --append --groups sudo "${TARGET_USER}"

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
# Install each suckless tool
# --------------------------------------------------
for tool in "${SUCKLESS_TOOLS[@]}"; do
    repo_dir="/opt/.base_repos/${tool}"
    repo_url="https://git.suckless.org/${tool}"

    if [[ ! -d "${repo_dir}" ]]; then
        log "Cloning ${repo_url}"
        git clone --depth 1 "${repo_url}" "${repo_dir}"
    else
        log "Updating ${repo_dir}"
        cd "${repo_dir}" || echo "Bad dir"
        git fetch --depth 1
        git reset --hard origin/HEAD
    fi

    cd "${repo_dir}" || echo "Bad dir"

    log "Building $(basename "${repo_dir}") from source"
    make clean || true
    make
    make install
done

# --------------------------------------------------
# Firmware
# --------------------------------------------------
log "Checking for firmware updates"
fwupdmgr --force --assume-yes refresh
fwupdmgr --force --assume-yes get-updates
fwupdmgr --force --assume-yes update

log "Post-install setup complete"


