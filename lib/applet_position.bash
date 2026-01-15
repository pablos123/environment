#!/usr/bin/env bash
set -Eeuo pipefail

# --------------------------------------------------
# Applet position calculator
# Calculate the position of an applet popup given x/y size.
# Use xwininfo to get the size of a window.
# --------------------------------------------------

readonly APPLET_X_GAP=16
readonly APPLET_Y_GAP=42

function calculate_applet_position() {
    local x_size y_size res

    x_size="${1:-}"
    y_size="${2:-}"

    if [[ -z "${x_size}" ]] || [[ ! "${x_size}" =~ ^[0-9]+$ ]] ||
       [[ -z "${y_size}" ]] || [[ ! "${y_size}" =~ ^[0-9]+$ ]]; then
        return 1
    fi

    # array: x y offset_x offset_y
    mapfile -t res < <(xrandr | grep 'connected primary' | awk '{print $4}' | tr x+ '\n\n')

    echo -n "$(( res[0] - x_size - APPLET_X_GAP + res[2] ))" "$(( res[1] - y_size - APPLET_Y_GAP + res[3] ))"
}
