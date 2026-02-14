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

log "Configuring DNS fallback"
mkdir -p /etc/NetworkManager/conf.d
cat > /etc/NetworkManager/conf.d/dns-servers.conf <<'DNSEOF'
[global-dns-domain-*]
servers=8.8.8.8,1.1.1.1
DNSEOF

log "Enabling NetworkManager"
systemctl enable NetworkManager
systemctl restart NetworkManager

log "Waiting for DNS resolution to come up"
for i in $(seq 1 30); do
    if getent hosts google.com > /dev/null 2>&1; then
        log "DNS is working"
        break
    fi
    if [[ "${i}" -eq 30 ]]; then
        die "DNS resolution failed after 30 seconds"
    fi
    sleep 1
done

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
# Docker
# --------------------------------------------------
log "Installing Docker"

apt install --yes ca-certificates
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "${VERSION_CODENAME}") stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install --yes docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

log "Adding ${TARGET_USER} to docker group"
usermod --append --groups docker "${TARGET_USER}"

systemctl enable docker

# --------------------------------------------------
# Dotfiles: .xinitrc
# --------------------------------------------------
log "Writing .xinitrc for ${TARGET_USER}"

TARGET_HOME="$(eval echo "~${TARGET_USER}")"

cat > "${TARGET_HOME}/.xinitrc" <<'XINITRC'
xrdb -merge ~/.Xresources 2>/dev/null
hsetroot -solid '#1a1b26' &
exec dwm
XINITRC

chown "${TARGET_USER}:${TARGET_USER}" "${TARGET_HOME}/.xinitrc"

# --------------------------------------------------
# Dotfiles: .bashrc
# --------------------------------------------------
log "Writing .bashrc for ${TARGET_USER}"

cat > "${TARGET_HOME}/.bashrc" <<'BASHRC'
# If not interactive, bail
[[ $- != *i* ]] && return

# --- History ---
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%F %T  "

# --- Shell options ---
shopt -s histappend
shopt -s checkwinsize
shopt -s cdspell
shopt -s dirspell
shopt -s autocd
shopt -s globstar
shopt -s cmdhist
shopt -s no_empty_cmd_completion

# --- Colors ---
RST='\[\e[0m\]'
BOLD='\[\e[1m\]'
RED='\[\e[31m\]'
GREEN='\[\e[32m\]'
YELLOW='\[\e[33m\]'
BLUE='\[\e[34m\]'
CYAN='\[\e[36m\]'

__git_branch() {
    local branch
    branch="$(git symbolic-ref --short HEAD 2>/dev/null)" || return
    printf ' (%s)' "${branch}"
}

if [[ "${EUID}" -eq 0 ]]; then
    PS1="${RED}${BOLD}\u${RST}@${YELLOW}\h${RST}:${BLUE}\w${RST}${CYAN}\$(__git_branch)${RST}# "
else
    PS1="${GREEN}${BOLD}\u${RST}@${YELLOW}\h${RST}:${BLUE}\w${RST}${CYAN}\$(__git_branch)${RST}\$ "
fi

# --- Aliases ---
alias ls='ls --color=auto'
alias ll='ls -lhF'
alias la='ls -AlhF'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias mkdir='mkdir -pv'
alias ..='cd ..'
alias ...='cd ../..'

# --- Completions ---
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
fi

# --- Path ---
export PATH="${HOME}/.local/bin:${PATH}"
export EDITOR="vim"
BASHRC

chown "${TARGET_USER}:${TARGET_USER}" "${TARGET_HOME}/.bashrc"

# --------------------------------------------------
# Firmware
# --------------------------------------------------
log "Checking for firmware updates"
fwupdmgr --force --assume-yes refresh
fwupdmgr --force --assume-yes get-updates
fwupdmgr --force --assume-yes update

log "Post-install setup complete"


