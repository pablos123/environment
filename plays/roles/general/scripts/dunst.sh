#!/bin/bash
#
# https://github.com/dunst-project/dunst
rm -rf "$HOME/.dunst"
git clone https://github.com/dunst-project/dunst.git "$HOME/.dunst"
cd "$HOME/.dunst" || exit 1
make
sudo make install
