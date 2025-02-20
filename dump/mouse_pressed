#!/usr/bin/env bash
# Exit if mouse's button is pressed.
# Usage: mouse_pressed [left:default|right|wheel]

button=1
if [[ -n $1 ]]; then
    if [[ $1 == "left" ]]; then
        button=1
    elif [[ $1 == "right" ]]; then
        button=3
    elif [[ $1 == "wheel" ]]; then
        button=2
    else
        echo "Usage: mouse_press [left:default|right|wheel]"
        exit 1
    fi
fi

# See what to set here with 'xinput --list'
XINPUT_MOUSE_ID=8
state="$(xinput --query-state "$XINPUT_MOUSE_ID" | grep "\[$button\]=")"
if [[ $state =~ "down" ]]; then
    exit 0
fi

exit 1
