#!/bin/bash
#

version="v2.3.3"
wget -O "$HOME/.local/share/fonts/SourceCodePro.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/$version/SourceCodePro.zip"
unzip -o "$HOME/.local/share/fonts/SourceCodePro.zip" -d "$HOME/.local/share/fonts/"
