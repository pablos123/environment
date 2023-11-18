#!/bin/bash
#
# Say NO to white screens
dconf write /org/gnome/desktop/interface/color-scheme \'prefer-dark\'

# Set chrome flatpak as the default browser
xdg-settings set default-web-browser 'com.google.Chrome.desktop'
