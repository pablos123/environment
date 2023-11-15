#!/bin/bash
#
# https://github.com/sainnhe/capitaine-cursors
# https://wiki.archlinux.org/title/Cursor_themes (the wiki is not very good)
# The correct way to do it is what I do in that last cp command.
rm -rf "$HOME/.icons/working/"
mkdir -p "$HOME/.icons/default/" "$HOME/.icons/working/"
wget -O "$HOME/.icons/working/cursor.zip" "https://github.com/sainnhe/capitaine-cursors/releases/download/r5/Linux.zip"
unzip -o "$HOME/.icons/working/cursor.zip" -d "$HOME/.icons/working/"
cp -rv "$HOME/.icons/working/Capitaine Cursors (Gruvbox)"/ "$HOME/.icons/"
rm -rf "$HOME/.icons/working/"

cp -rv "$HOME/.icons/Capitaine Cursors (Gruvbox)"/* "$HOME/.icons/default"
# If the above is not enough maybe this solve the problem
# sudo ln -sf "$HOME/.icons/default" "/usr/share/icons/default"

# https://github.com/SylEleuth/gruvbox-plus-icon-pack
rm -rf "$HOME/.repos/icons/working/"
mkdir -p "$HOME/.icons/" "$HOME/.repos/icons/working/"
git clone https://github.com/SylEleuth/gruvbox-plus-icon-pack.git "$HOME/.repos/icons/working/"
rm -rf "$HOME/.icons/Gruvbox-Plus-Dark/"
cp -rv "$HOME/.repos/icons/working/Gruvbox-Plus-Dark/" "$HOME/.icons/"
rm -rf "$HOME/.repos/icons/working/"

# https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme
rm -rf "$HOME/.repos/themes/working/"
mkdir -p "$HOME/.themes/" "$HOME/.repos/themes/working/"
git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme "$HOME/.repos/themes/working/"
rm -rf "$HOME/.themes/Gruvbox-Dark-BL/"
cp -rv "$HOME/.repos/themes/working/themes/Gruvbox-Dark-BL/" "$HOME/.themes/"
rm -rf "$HOME/.repos/themes/working/"

# Give flatpak the same gtk theme
sudo flatpak override --filesystem="$HOME/.themes"
sudo flatpak override --filesystem="$HOME/.icons"

sudo flatpak override --env=GTK_THEME="Gruvbox-Dark-BL"
sudo flatpak override --env=ICON_THEME="Gruvbox-Plus-Dark"

