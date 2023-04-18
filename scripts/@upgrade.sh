#!/bin/bash
#
source "$HOME/environment/scripts/fzf.sh"
source "$HOME/environment/scripts/lazygit.sh"

sudo apt update
sudo apt full-upgrade
sudo flatpak update
sudo apt autopurge

source "$HOME/environment/scripts/clean.sh"
