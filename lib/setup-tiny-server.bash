#!/usr/bin/env bash

# One-shot post-install setup for a fresh Debian server.

set -Eeuo pipefail

source "/home/pab/environment/lib/helpers.bash"

declare -r TARGET_USER="pab"

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

function require_root {
    if [[ "${EUID}" -ne 0 ]]; then
        die "Run this script as root"
    fi
}

function main {
    local target_home repo_dir repo_url repo_name

    require_root

    log "Starting Debian headless tiny server post-install setup"

    log "Removing cdrom entries from APT sources"

    if ! sed --in-place '/^deb cdrom:/d' /etc/apt/sources.list; then
        :
    fi

    if [[ -d /etc/apt/sources.list.d ]]; then
        if ! sed --in-place '/^deb cdrom:/d' /etc/apt/sources.list.d/*.list; then
            :
        fi
    fi

    log "Updating and upgrading packages"
    apt update
    apt upgrade --yes
    apt autopurge --yes

    log "Installing base packages"

    apt install --yes "${APT_PACKAGES[@]}"

    log "Installing NetworkManager"
    apt install --yes network-manager

    log "Disabling legacy ifupdown networking"
    rm --force /etc/network/interfaces

    if ! systemctl disable networking.service; then
        :
    fi
    if ! systemctl stop networking.service; then
        :
    fi

    if ! apt purge --yes ifupdown; then
        :
    fi

    log "Configuring DNS fallback"
    mkdir --parents /etc/NetworkManager/conf.d
    cat >/etc/NetworkManager/conf.d/dns-servers.conf <<'DNSEOF'
[global-dns-domain-*]
servers=8.8.8.8,1.1.1.1
DNSEOF

    log "Enabling NetworkManager"
    systemctl enable NetworkManager
    systemctl restart NetworkManager

    log "Waiting for DNS resolution to come up"
    local -i i
    for ((i = 1; i <= 30; i++)); do
        if getent hosts google.com >/dev/null 2>&1; then
            log "DNS is working"
            break
        fi
        if ((i == 30)); then
            die "DNS resolution failed after 30 seconds"
        fi
        sleep 1
    done

    log "Granting sudo access to ${TARGET_USER}"
    usermod --append --groups sudo "${TARGET_USER}"

    log "Removing apt unstable cli interface warning"
    echo "Apt::Cmd::Disable-Script-Warning true;" | tee /etc/apt/apt.conf.d/90disablescriptwarning

    log "Configuring correct timezone"
    timedatectl set-timezone America/Argentina/Buenos_Aires

    local tool
    for tool in "${SUCKLESS_TOOLS[@]}"; do
        repo_dir="/opt/.base_repos/${tool}"
        repo_url="https://git.suckless.org/${tool}"

        if [[ ! -d "${repo_dir}" ]]; then
            log "Cloning ${repo_url}"
            git clone --depth 1 "${repo_url}" "${repo_dir}"
        else
            log "Updating ${repo_dir}"
            if ! cd "${repo_dir}"; then
                die "could not cd into ${repo_dir}"
            fi
            git fetch --depth 1
            git reset --hard origin/HEAD
        fi

        if ! cd "${repo_dir}"; then
            die "could not cd into ${repo_dir}"
        fi

        repo_name="${repo_dir##*/}"
        log "Building ${repo_name} from source"
        if ! make clean; then
            :
        fi
        make
        make install
    done

    log "Installing Docker"

    apt install --yes ca-certificates
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    local arch codename
    arch="$(dpkg --print-architecture)"
    source /etc/os-release
    # shellcheck disable=SC2154  # VERSION_CODENAME is defined by /etc/os-release
    codename="${VERSION_CODENAME}"

    printf 'deb [arch=%s signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian %s stable\n' \
        "${arch}" "${codename}" |
        tee /etc/apt/sources.list.d/docker.list >/dev/null

    apt update
    apt install --yes docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    log "Adding ${TARGET_USER} to docker group"
    usermod --append --groups docker "${TARGET_USER}"

    systemctl enable docker

    log "Writing .xinitrc for ${TARGET_USER}"

    target_home="$(getent passwd "${TARGET_USER}" | cut -d: -f6)"

    cat >"${target_home}/.xinitrc" <<'XINITRC'
xrdb -merge ~/.Xresources 2>/dev/null
hsetroot -solid '#1a1b26' &
exec dwm
XINITRC

    chown "${TARGET_USER}:${TARGET_USER}" "${target_home}/.xinitrc"

    log "Writing .bashrc for root"

    cat >/root/.bashrc <<'BASHRC'
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
    source /usr/share/bash-completion/bash_completion
fi

# --- Path ---
export PATH="${HOME}/.local/bin:${PATH}"
export EDITOR="vim"

# --- Disable bell ---
bind 'set bell-style none'
BASHRC

    log "Writing .bash_profile for root"

    cat >/root/.bash_profile <<'BPROFILE'
[[ -f ~/.bashrc ]] && . ~/.bashrc
BPROFILE

    log "Writing .bashrc for ${TARGET_USER}"
    cp /root/.bashrc "${target_home}/.bashrc"
    chown "${TARGET_USER}:${TARGET_USER}" "${target_home}/.bashrc"

    log "Writing .bash_profile for ${TARGET_USER}"
    cp /root/.bash_profile "${target_home}/.bash_profile"
    chown "${TARGET_USER}:${TARGET_USER}" "${target_home}/.bash_profile"

    log "Disabling bell system-wide"

    cat >/etc/inputrc <<'INPUTRC'
$include /etc/inputrc.dpkg-dist
set bell-style none
INPUTRC

    echo "blacklist pcspkr" >/etc/modprobe.d/nobeep.conf
    echo "blacklist snd_pcsp" >>/etc/modprobe.d/nobeep.conf

    log "Configuring EU keyboard layout"

    cat >/etc/default/keyboard <<'KBEOF'
XKBMODEL="pc105"
XKBLAYOUT="eu"
XKBVARIANT=""
XKBOPTIONS="caps:swapescape"
BACKSPACE="guess"
KBEOF

    if ! setupcon --force 2>/dev/null; then
        :
    fi

    log "Checking for firmware updates"
    fwupdmgr --force --assume-yes refresh
    fwupdmgr --force --assume-yes get-updates
    fwupdmgr --force --assume-yes update

    log "Post-install setup complete"
}

main "$@"
