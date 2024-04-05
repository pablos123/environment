#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source "$HOME/.bashrc_variables"
source "$HOME/.git-prompt.sh" # __git_ps1 command in PS1

PS1='\[\e\][0;32m \[\w\] \[\e\][1;33m $(__git_ps1 "(  %s )")\[\e\][0m\n🍂 '

source "$HOME/.bashrc_aliases"

source "$HOME/.bashrc_functions"

if [[ -f "$HOME/.bashrc_work" ]]; then
    source "$HOME/.bashrc_work"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

load_completions

calendar_fact
