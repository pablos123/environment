#!/usr/bin/env bash

# Calculator to support different monitor sizes for my custom applets.
# Calculate the position of the an applet popup given an x/y axis and an applet's x/y size.
# You can get the size of a window with: xwininfo

function calculate_applet_position() {
    local x_size y_size res x_gap y_gap
    x_size="${1}"
    y_size="${2}"

    [[ -z "${x_size}" ]] || [[ ! "${x_size}" =~ ^[0-9]+$ ]] ||
    [[ -z "${y_size}" ]] || [[ ! "${y_size}" =~ ^[0-9]+$ ]] &&
        exit 1

    x_gap=16
    y_gap=42

    # array: x y offset_x offset_y
    mapfile -t res < <(xrandr | grep 'connected primary' | awk '{print $4}' | tr x+ '\n\n')

    echo -n "$(( res[0] - x_size - x_gap + res[2] ))" "$(( res[1] - y_size - y_gap + res[3] ))"
}
