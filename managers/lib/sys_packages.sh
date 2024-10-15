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
# https://github.com/sharkdp/fd
# https://github.com/junegunn/fzf
# https://github.com/zellij-org/zellij

apt_packages=(
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
  lsb-release
  nemo
  i3
  pulseaudio
  apulse
  terminator
  upower
  network-manager
  ncal
  gtk2-engines-murrine
  firefox
  cinnamon
  mintupgrade
  solaar
)

cargo_packages=(
  eza
  fd-find
  zellij
)

pip_packages=(
  speedtest-cli
)

