#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

source "${HOME}/environment/lib/helpers.bash"

require_commands sudo systemctl

function main {
    log "Disabling bell system-wide"

    sudo tee /etc/inputrc >/dev/null <<'INPUTRC'
$include /etc/inputrc.dpkg-dist
set bell-style none
INPUTRC

    sudo tee /etc/modprobe.d/nobeep.conf >/dev/null <<'BEEPEOF'
blacklist pcspkr
blacklist snd_pcsp
BEEPEOF

    log "Configuring EU keyboard layout"

    sudo tee /etc/default/keyboard >/dev/null <<'KBEOF'
XKBMODEL="pc105"
XKBLAYOUT="eu"
XKBVARIANT=""
XKBOPTIONS=""
BACKSPACE="guess"
KBEOF

    sudo setupcon --force 2>/dev/null || true

    log "Configuring keyd for key remapping"

    sudo mkdir --parents /etc/keyd

    sudo tee /etc/keyd/default.conf >/dev/null <<'KDEOF'
[ids]
*
# foostan Corne, remapped in its own firmware
-4653:0001

[main]
capslock = escape
escape = capslock
KDEOF

    sudo tee /etc/keyd/logitech-bolt.conf >/dev/null <<'KDEOF'
[ids]
*Logi Bolt Receiver*

[main]
leftalt = layer(meta)
leftmeta = layer(alt)
rightalt = layer(control)
rightmeta = layer(altgr)
KDEOF

    sudo systemctl enable keyd >/dev/null
    sudo systemctl restart keyd

    log "Configuring keyboard auto repeat"

    sudo mkdir --parents /etc/X11/xorg.conf.d

    # Applied on device init, so hotplugged keyboards keep the rate too
    sudo tee /etc/X11/xorg.conf.d/50-keyboard-autorepeat.conf >/dev/null <<'AREOF'
Section "InputClass"
    Identifier "keyboard autorepeat"
    MatchIsKeyboard "on"
    Option "AutoRepeat" "230 50"
EndSection
AREOF

    log "Configuring PAM to auto-unlock GNOME Keyring on login"

    if ! grep --quiet 'pam_gnome_keyring.so' /etc/pam.d/login; then
        sudo sed --in-place '/@include common-auth/a auth       optional   pam_gnome_keyring.so' /etc/pam.d/login
        sudo sed --in-place '/@include common-session/a session    optional   pam_gnome_keyring.so auto_start' /etc/pam.d/login
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

    log "Adding pre-login console banner"

    # agetty prints /etc/issue then /etc/issue.d/*.issue before the login
    # prompt. /etc/issue is a base-files conffile, so leave it alone and drop
    # ours alongside, regenerated on every getty spawn for live stats.
    sudo mkdir --parents /etc/issue.d

    sudo tee /usr/local/bin/issue-banner >/dev/null <<'BANNEREOF'
#!/usr/bin/env bash

set -Eeuo pipefail

readonly DIM=$'\033[2m'
readonly TEXT=$'\033[38;5;252m'
readonly ACCENT=$'\033[1;38;5;213m'
readonly RESET=$'\033[0m'
readonly SEP="${DIM} · ${RESET}${TEXT}"

function disk {
    local -i used
    used="$(df --output=pcent / | tail --lines 1 | tr --delete ' %')"

    local colour
    if ((used > 90)); then
        colour=$'\033[38;5;203m'
    elif ((used > 75)); then
        colour=$'\033[38;5;215m'
    else
        colour=$'\033[38;5;114m'
    fi

    printf '%sdisk %s%d%%%s' "${DIM}" "${colour}" "${used}" "${RESET}"
}

function battery {
    local bat capacity colour
    for bat in /sys/class/power_supply/BAT*; do
        [[ -r "${bat}/capacity" ]] || continue
        capacity="$(<"${bat}/capacity")"

        if ((capacity > 50)); then
            colour=$'\033[38;5;114m'
        elif ((capacity > 20)); then
            colour=$'\033[38;5;215m'
        else
            colour=$'\033[38;5;203m'
        fi

        local charging=''
        [[ "$(<"${bat}/status")" == "Charging" ]] && charging='+'
        printf '%s%sbat %s%s%%%s%s' \
            "${SEP}" "${DIM}" "${colour}" "${capacity}" "${charging}" "${RESET}"
        return 0
    done
}

# \n \l \4 \d \t stay as agetty escapes: expanded per tty at print time.
{
    printf '\n%s%s%s%s%s%s\\l%s\\4%s\n' \
        "${ACCENT}" \
        "$(. /etc/os-release && printf '%s' "${PRETTY_NAME//\//+}")" \
        "${RESET}" "${SEP}" \
        "$(uname --kernel-release)" "${SEP}" "${SEP}" "${RESET}"
    printf '%s\\n%s%s%s%s\n' "${TEXT}" "${RESET}" "${SEP}" "$(disk)" "$(battery)"
    printf '%s\\t  \\d%s\n\n' "${DIM}" "${RESET}"
} >/etc/issue.d/10-environment.issue
BANNEREOF

    sudo chmod +x /usr/local/bin/issue-banner

    sudo mkdir --parents /etc/systemd/system/getty@.service.d
    sudo tee /etc/systemd/system/getty@.service.d/banner.conf >/dev/null <<'EOF'
[Service]
ExecStartPre=-/usr/local/bin/issue-banner
EOF

    sudo systemctl daemon-reload
    sudo /usr/local/bin/issue-banner
}

main "$@"
