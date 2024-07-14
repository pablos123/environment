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

apt_common_packages=(
  ripgrep
  vim
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
  xterm
  cowsay
  lolcat
  fortune-mod
  espeak
  keepassxc
  picom
  xdotool
  xclip
  xsel
  hsetroot
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

apt_minimal_packages=(
  python3-full
  firefox-esr
  ntfs-3g
  ncal
  upower
)
apt_full_packages=(
  lightdm
  lightdm-gtk-greeter
  gtk2-engines-murrine
  firefox
)

cargo_packages=(
  eza
)

pip_packages=(
  speedtest-cli
)

