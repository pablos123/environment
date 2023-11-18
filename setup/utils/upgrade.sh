#!/bin/bash
#
yes | "$HOME/environment/setup/installers/fzf.sh"
yes | "$HOME/environment/setup/installers/lazygit.sh"
"$HOME/environment/setup/installers/vscode.sh"

sudo apt update -y
sudo apt full-upgrade -y
sudo flatpak update -y
sudo apt autopurge -y
