#!/usr/bin/env bash


function install_chrome() {
    curl -fsSL 'https://dl-ssl.google.com/linux/linux_signing_key.pub' | sudo gpg --yes --dearmor -o /usr/share/keyrings/google-chrome.gpg
    (echo 'deb [signed-by=/usr/share/keyrings/google-chrome.gpg arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list) > /dev/null
    sudo apt-get update
    sudo apt-get install --yes google-chrome-stable xdg-utils

    xdg-settings set default-web-browser 'google-chrome.desktop'

    # Fix emojis not rendering
    sudo apt-get install --yes fonts-noto-color-emoji

    # Fix fonts rendering incorrectly. Disable the next flag
    # chrome://flags/#enable-gpu-rasterization
}

install_chrome
