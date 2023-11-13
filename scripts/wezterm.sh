#!/bin/bash
#
wget -O './wezterm.deb' 'https://github.com/wez/wezterm/releases/download/20230712-072601-f4abf8fd/wezterm-20230712-072601-f4abf8fd.Ubuntu22.04.deb'
sudo apt install -y './wezterm.deb'
rm -f './wezterm.deb'
