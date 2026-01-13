#!/usr/bin/env bash
# --------------------------------------------------
# NOTE:
# This file is intended to be SOURCED, not executed.
# Must be compatible with set -Eeuo pipefail.
# --------------------------------------------------

# --------------------------------------------------
# Google Chrome repository
# --------------------------------------------------
if [[ ! -f "/usr/share/keyrings/google-chrome.gpg" ]]; then
    curl --fail --silent --show-error --location \
        'https://dl-ssl.google.com/linux/linux_signing_key.pub' \
    | sudo gpg --yes --dearmor \
        --output /usr/share/keyrings/google-chrome.gpg
fi

if [[ ! -f "/etc/apt/sources.list.d/google-chrome.list" ]]; then
    echo \
        'deb [signed-by=/usr/share/keyrings/google-chrome.gpg arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' \
    | sudo tee /etc/apt/sources.list.d/google-chrome.list >/dev/null
fi

# --------------------------------------------------
# Packages
# --------------------------------------------------
sudo apt update >/dev/null

sudo apt install --yes \
    google-chrome-stable \
    xdg-utils \
    fonts-noto-color-emoji \
    >/dev/null

# Fix fonts rendering incorrectly:
# Disable the flag chrome://flags/#enable-gpu-rasterization

# --------------------------------------------------
# Default browser
# --------------------------------------------------
if command -v xdg-settings >/dev/null; then
    xdg-settings set default-web-browser 'google-chrome.desktop' || true
fi
