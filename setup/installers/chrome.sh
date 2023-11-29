#!/bin/bash

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo add-apt-repository "deb http://dl.google.com/linux/chrome/deb/ stable main"
sudo apt update
sudo apt install -y google-chrome-stable

# Say NO to white screens
dconf write /org/gnome/desktop/interface/color-scheme \'prefer-dark\'
# Set chrome as the default browser
xdg-settings set default-web-browser 'google-chrome.desktop'
