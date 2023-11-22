#!/bin/bash
#
cd "$HOME/dotfiles/" || exit 1
stow --target="$HOME" --restow -- */
