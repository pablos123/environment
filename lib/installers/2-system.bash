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
}

main "$@"
