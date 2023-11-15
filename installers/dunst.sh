#!/bin/bash
#
# https://github.com/dunst-project/dunst
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

sudo apt install -y "${dependencies[@]}"

rm -rf "$HOME/.dunst"
git clone https://github.com/dunst-project/dunst.git "$HOME/.dunst"
cd "$HOME/.dunst" || exit 1
make
sudo make install
