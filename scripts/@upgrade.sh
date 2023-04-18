#!/bin/bash
#
"$HOME/environment/scripts/fzf.sh"
"$HOME/environment/scripts/lazygit.sh"

sudo apt update
sudo apt full-upgrade
sudo flatpak update
sudo apt autopurge

"$HOME/environment/scripts/clean.sh"
