#!/usr/bin/env bash
#
#
# DOCS
# https://github.com/muesli/duf
# https://github.com/sharkdp/hyperfine
# https://github.com/stedolan/jq
# https://github.com/BurntSushi/ripgrep
# https://github.com/sharkdp/bat
# https://github.com/sivel/speedtest-cli
# https://github.com/eza-community/eza

apt_packages=(
  firefox

  ripgrep
  duf
  jq
  git
  bat
  hyperfine
  yad
  tree
  htop
  stow
  at
  tmux
  screen
  progress
  anacron
  calendar
  imagemagick
  wmctrl

  sxiv
  mpv
  kolourpaint
  flameshot
  scrot
  gpick
  zathura
  zathura-djvu
  ffmpeg
  xchm
  unzip
  7zip
  cmus

  cowsay
  lolcat
  fortune-mod
  espeak
  keepassxc

  picom
  xdotool
  xclip
  xsel
  lightdm
  lightdm-gtk-greeter
  hsetroot
  gtk2-engines-murrine
  x11-xserver-utils
  xdg-utils
  inotify-tools
  libnotify-bin

  cbm
  iftop
  nload

  python3-venv
  cargo
  golang
  luarocks
  cpanminus
)

cargo_packages=(
  eza
)

pip_packages=(
  speedtest-cli
)
