#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if xset -b b off &>>/dev/null; then
   keyboard_config
fi

shopt -s direxpand
shopt -s autocd

source "$HOME/.bash_variables"
source "$HOME/.git-prompt.sh"
source "$HOME/.bash_aliases"
source "$HOME/.bash_functions"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

load_completions

if [[ -f "$HOME/.bashrc_custom" ]]; then
    source "$HOME/.bashrc_custom"
fi

# nvm setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
