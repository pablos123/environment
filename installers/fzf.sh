#!/bin/bash
#
# https://github.com/junegunn/fzf
rm -rf "$HOME/.fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
yes | "$HOME/.fzf/install"