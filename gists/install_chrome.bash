#!/usr/bin/env bash
set -Eeuo pipefail

# --------------------------------------------------
# Google Chrome repository
# --------------------------------------------------
if [[ ! -f "/usr/share/keyrings/google-chrome.gpg" ]]; then
    echo "==> Setting up Google Chrome repository"
    curl --fail --no-progress-meter --location \
        'https://dl-ssl.google.com/linux/linux_signing_key.pub' \
    | sudo gpg --yes --dearmor \
        --output /usr/share/keyrings/google-chrome.gpg
fi

if [[ ! -f "/etc/apt/sources.list.d/google-chrome.list" ]]; then
    echo \
        'deb [signed-by=/usr/share/keyrings/google-chrome.gpg arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' \
    | sudo tee /etc/apt/sources.list.d/google-chrome.list
fi

# --------------------------------------------------
# Packages
# --------------------------------------------------
sudo apt-get update

echo "==> Installing Google Chrome"
sudo apt-get install --yes \
    google-chrome-stable \
    xdg-utils \
    fonts-noto-color-emoji

# Fix fonts rendering incorrectly:
# Disable the flag chrome://flags/#enable-gpu-rasterization

# --------------------------------------------------
# Default browser
# --------------------------------------------------
if command -v xdg-settings; then
    echo "==> Setting default browser"
    xdg-settings set default-web-browser 'google-chrome.desktop' || true
fi
