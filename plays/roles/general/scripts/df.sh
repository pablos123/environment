#/bin/bash
#
mkdir -P "$HOME/.df"
wget -O "$HOME/.df/df.zip" 'https://www.bay12games.com/dwarves/df_50_07_win.zip'
unzip "$HOME/.df/df.zip" -d "$HOME/.df/"
