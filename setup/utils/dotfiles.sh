#!/bin/bash
#
cd "$HOME/environment/dotfiles/" || exit 1
stow --target="$HOME" --restow -- */
