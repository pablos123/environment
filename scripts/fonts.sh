#!/bin/bash
#

version="v3.0.2"

install_font() {
    wget -O "$HOME/.local/share/fonts/$1.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/$version/$1.zip"
    unzip -o "$HOME/.local/share/fonts/$1.zip" -d "$HOME/.local/share/fonts/$1"
    rm -f "$HOME/.local/share/fonts/$1.zip"
}

install_font "SourceCodePro"
install_font "Cousine"
install_font "JetBrainsMono"
install_font "Lilex"
install_font "DejaVuSansMono"
install_font "FiraMono"

fc-cache -fv
