#!/bin/bash
#
rm -f "$HOME/environment/plays/keyring.deb"
rm -f "$HOME/environment/plays/lazygit"
rm -f "$HOME/environment/plays/lazygit.tar.gz"

rm -f "$HOME/environment/scripts/lazygit"
rm -f "$HOME/environment/scripts/lazygit.tar.gz"

rm -f ./lazygit
rm -f ./lazygit.tar.gz

sudo apt purge steam wine

rm -f "$HOME/.cache/dmenu_run"
rm -f "$HOME/dmenu_cache"

sudo apt autopurge