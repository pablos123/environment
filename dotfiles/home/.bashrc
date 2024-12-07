#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if xset -b b off &>>/dev/null; then keyboard_config; fi

shopt -s direxpand
shopt -s autocd

source "${HOME}/.bash_variables"
source "${HOME}/.git-prompt.sh"
source "${HOME}/.bash_aliases"
source "${HOME}/.bash_functions"

[[ -s ${HOME}/.fzf.bash ]] && source ${HOME}/.fzf.bash

load_completions

if [[ -f "${HOME}/.bashrc_custom" ]]; then
    source "${HOME}/.bashrc_custom"
fi

export NVM_DIR="${HOME}/.nvm"
[[ -s "${NVM_DIR}/nvm.sh" ]] && source "${NVM_DIR}/nvm.sh"
[[ -s "${NVM_DIR}/bash_completion" ]] && source "${NVM_DIR}/bash_completion"

[[ -s "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"

command -v pyenv >/dev/null && eval "$(pyenv init -)"
