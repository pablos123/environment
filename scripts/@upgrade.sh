#!/bin/bash
#
yes | "$HOME/environment/scripts/fzf.sh"
yes | "$HOME/environment/scripts/lazygit.sh"

sudo (yes "yes" | apt update)
sudo (yes "yes" | apt full-upgrade)
sudo (yes "yes" | flatpak update)
sudo (yes "yes" | apt autopurge)

"$HOME/environment/scripts/clean.sh"
