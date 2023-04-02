#!/bin/bash
#
# https://github.com/sainnhe/capitaine-cursors
# https://wiki.archlinux.org/title/Cursor_themes (the wiki is not very good)
# The correct way to do it is what I do in that last cp command.
mkdir -p "$HOME/.icons/default"
wget -O "$HOME/.icons/cursor.zip" "https://github.com/sainnhe/capitaine-cursors/releases/download/r5/Linux.zip"
unzip -o "$HOME/.icons/cursor.zip" -d "$HOME/.icons/"

cp -r "$HOME/.icons/Capitaine Cursors (Gruvbox)"/* "$HOME/.icons/default"
sudo ln -sf "$HOME/.icons/default/" "/usr/share/icons/default"

# https://github.com/SylEleuth/gruvbox-plus-icon-pack
mkdir -p "$HOME/.icons"
rm -rf "$HOME/.icons/gruvbox_icons"
git clone https://github.com/SylEleuth/gruvbox-plus-icon-pack "$HOME/.icons/gruvbox_icons"

# https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme
mkdir -p "$HOME/.themes"
rm -rf "$HOME/.themes/gruvbox"
git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme "$HOME/.themes/gruvbox"
rm -rf "$HOME/.themes/Gruvbox-Dark-BL"
mv "$HOME/.themes/gruvbox/themes/Gruvbox-Dark-BL" "$HOME/.themes/"
