#!/bin/bash
#
yes | "$HOME/environment/scripts/fzf.sh"
yes | "$HOME/environment/scripts/lazygit.sh"
yes | "$HOME/environment/scripts/vscode.sh"

sudo apt update -y
sudo apt full-upgrade -y
sudo flatpak update -y
sudo apt autopurge -y

"$HOME/environment/scripts/clean.sh"
