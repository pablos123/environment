#!/usr/bin/env bash

function install_fonts() {
    local font fonts fonts_path

    fonts=(
        SourceCodePro
        JetBrainsMono
        Lilex
    )

    fonts_path="${HOME}/.local/share/fonts"

    mkdir -p "${fonts_path}"
    for font in "${fonts[@]}"; do
        rm -rf "${fonts_path}/${font}Nerd"
        mkdir -p "${fonts_path}/${font}Nerd"
        wget -O "${fonts_path}/${font}Nerd.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.tar.xz"
        tar -xf "${fonts_path}/${font}Nerd.tar.xz" -C "${fonts_path}/${font}Nerd"
        rm -f "${fonts_path}/${font}Nerd.tar.xz"
    done
}

install_fonts
