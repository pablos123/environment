#!/bin/bash
#
source "./fzf.sh"
source "./lazygit.sh"

sudo apt update
sudo apt full-upgrade
sudo flatpak update
sudo apt autopurge

source "./clean.sh"
