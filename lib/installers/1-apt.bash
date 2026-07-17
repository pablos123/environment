#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

source "${HOME}/environment/lib/helpers.bash"

require_commands sudo apt

declare -ra APT_PACKAGES=(
    xorg
    build-essential
    pipewire-audio
    pulseaudio-utils
    pavucontrol
    network-manager
    network-manager-gnome
    dbus-x11
    bluetooth
    bluez
    bluez-firmware
    firmware-iwlwifi
    blueman
    x11-xserver-utils
    autorandr
    xdg-utils
    i3-wm
    i3lock
    rofi
    polybar
    vim
    duf
    jq
    git
    bat
    tree
    stow
    at
    fd-find
    gpg
    direnv
    ripgrep
    hyperfine
    progress
    htop
    btop
    nvtop
    wavemon
    lsb-release
    upower
    solaar
    ncal
    valgrind
    zathura
    zathura-djvu
    zathura-ps
    zathura-cb
    ffmpeg
    sxiv
    mpv
    imagemagick
    zip
    unzip
    unrar-free
    7zip
    tar
    img2pdf
    flameshot
    zbar-tools
    scrot
    hsetroot
    cowsay
    lolcat
    calendar
    fortune-mod
    espeak
    wmctrl
    xdotool
    xclip
    xsel
    xfe
    pkexec
    inotify-tools
    libnotify-bin
    python3-venv
    luarocks
    yad
    keepassxc
    picom
    bash-completion
    pipx
    curl
    zenity
    shellcheck
    entr
    libreoffice
    pandoc
    meld
    aria2
    redshift
    tmux
    brightnessctl
    inxi
    eza
    thunderbird
    gnome-themes-extra
    papirus-icon-theme
    fonts-noto-color-emoji
    fwupd
    sshfs
    keyd
    shfmt
)

function main {
    log "Updating system packages"
    sudo apt update
    sudo apt full-upgrade --yes

    log "Installing APT packages"
    sudo apt install --yes "${APT_PACKAGES[@]}"

    if command -v fdfind >/dev/null; then
        log "Creating fd compatibility symlink"
        mkdir --parents "${HOME}/.local/bin"
        local fdfind_path
        fdfind_path="$(command -v fdfind)"
        ln --symbolic --force "${fdfind_path}" "${HOME}/.local/bin/fd"
    fi

    log "Adding autorandr hotplug EDID-settle delay"
    sudo mkdir --parents /etc/systemd/system/autorandr.service.d
    sudo tee /etc/systemd/system/autorandr.service.d/delay.conf >/dev/null <<'EOF'
[Service]
# Wait for a hotplugged monitor's EDID to become readable.
ExecStartPre=/bin/sleep 2
# Drop --default default: no such profile, so every run errors.
ExecStart=
ExecStart=/usr/bin/autorandr --batch --change
EOF

    log "Adding autorandr lid-switch ACPI-settle delay"
    sudo mkdir --parents /etc/systemd/system/autorandr-lid-listener.service.d
    sudo tee /etc/systemd/system/autorandr-lid-listener.service.d/delay.conf >/dev/null <<'EOF'
[Service]
# libinput reports the toggle before /proc/acpi/button/lid settles, so sleep
# inside the loop. ExecStartPre would only delay the listener's own startup.
ExecStart=
ExecStart=sh -c "stdbuf -oL libinput debug-events | grep -E --line-buffered '^[[:space:]-]+event[0-9]+[[:space:]]+SWITCH_TOGGLE[[:space:]]' | while read line; do sleep 1; autorandr --batch --change; done"
EOF
    sudo systemctl daemon-reload
}

main "$@"
