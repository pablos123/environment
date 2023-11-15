#!/bin/bash
#
yes | "$HOME/environment/installers/fzf.sh"
yes | "$HOME/environment/installers/lazygit.sh"

"$HOME/environment/scripts/vscode.sh"

sudo apt update -y
sudo apt full-upgrade -y
sudo flatpak update -y
sudo apt autopurge -y
