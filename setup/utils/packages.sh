#!/bin/bash
#
#
# DOCS
# https://github.com/ogham/exa
# https://github.com/cmus/cmus
# https://github.com/muesli/duf
# https://github.com/sharkdp/hyperfine
# https://github.com/dduan/tre
# https://github.com/stedolan/jq
# https://github.com/BurntSushi/ripgrep
# https://github.com/sharkdp/bat
# https://github.com/jarun/nnn
# https://github.com/sivel/speedtest-cli
# https://github.com/eradman/entr

apt_packages=(
  exa
  duf
  entr
  hyperfine
  tre-command
  ripgrep
  jq
  bat
  nnn
  firefox
  chromium
  zathura
  zathura-djvu
  xchm
  xdotool
  cmus
  sqlitebrowser
  git
  d-feet
  yad
  tree
  htop
  scrot
  at
  xclip
  xsel
  tmux
  stow
  progress
  newsboat
  libnotify-bin
  anacron
  calendar
  ffmpeg
  imagemagick
  sxiv
  mpv
  vlc
  mypaint
  kolourpaint
  unzip
  cowsay
  lolcat
  fortune-mod
  hsetroot
  neofetch
  picom
  flameshot
  gpick
  wmctrl
  espeak
  keepassxc
  flatpak
  cargo
  golang
  luarocks
  cpanminus
  python3-venv
  lightdm
  lightdm-gtk-greeter
  gtk2-engines-murrine
  x11-xserver-utils
  xdg-utils
  iftop
  cbm
  tcptrack
  nload
  virtualbox
  vagrant
)

flatpak_packages=(
  io.dbeaver.DBeaverCommunity
  md.obsidian.Obsidian
  com.spotify.Client
  com.github.tchx84.Flatseal
)

pip_packages=(
  speedtest-cli
)
