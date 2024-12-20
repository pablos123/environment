#!/usr/bin/env bash

chrome_installer() {
    curl -fsSL 'https://dl-ssl.google.com/linux/linux_signing_key.pub' | sudo gpg --yes --dearmor -o /usr/share/keyrings/google-chrome.gpg
    (echo 'deb [signed-by=/usr/share/keyrings/google-chrome.gpg arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list) > /dev/null
    sudo apt-get update
    sudo apt-get install -y google-chrome-stable

    dconf write /org/gnome/desktop/interface/color-scheme \'prefer-dark\'
    xdg-settings set default-web-browser 'google-chrome.desktop'
}

wezterm_installer() {
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    (echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list) > /dev/null
    sudo apt-get update
    sudo apt-get install -y wezterm
}

dunst_installer() {
    local dependencies
    dependencies=(
      libdbus-1-dev
      libx11-dev
      libxinerama-dev
      libxrandr-dev
      libxss-dev
      libglib2.0-dev
      libpango1.0-dev
      libgtk-3-dev
      libxdg-basedir-dev
      libnotify-dev
    )

    sudo apt-get install -y "${dependencies[@]}"

    rm -rf "$HOME/.dunst"
    git clone https://github.com/dunst-project/dunst.git "$HOME/.dunst"
    (
        cd "$HOME/.dunst" || exit 1
        make
        sudo make install
    ) > /dev/null
}

# https://github.com/junegunn/fzf
fzf_installer() {
    rm -rf "$HOME/.fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    (yes | "$HOME/.fzf/install") > /dev/null
}

independent_installers=(
    dunst_installer
    fzf_installer
    chrome_installer
    wezterm_installer
)
