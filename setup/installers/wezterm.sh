#!/bin/bash
#
wget -O './wezterm.deb' 'https://github.com/wez/wezterm/releases/download/20240127-113634-bbcac864/wezterm-20240127-113634-bbcac864.Ubuntu22.04.deb'
sudo apt install -y './wezterm.deb'
rm -f './wezterm.deb'
