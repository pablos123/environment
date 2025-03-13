#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] &&
    return

shopt -s direxpand
shopt -s autocd

. "${HOME}/environment/lib/env_variables.sh"
source "${HOME}/environment/lib/aliases.sh"
source "${HOME}/environment/lib/bash_functions.sh"
source "${HOME}/environment/lib/git_prompt.sh"

[[ -f /usr/share/bash-completion/bash_completion ]] &&
    source /usr/share/bash-completion/bash_completion

[[ -f "${HOME}/.fzf.bash" ]] &&
    source ${HOME}/.fzf.bash

[[ -f "${HOME}/.bashrc_custom" ]] &&
    source "${HOME}/.bashrc_custom"

[[ -f "${NVM_DIR}/nvm.sh" ]] &&
    source "${NVM_DIR}/nvm.sh"

[[ -f "${NVM_DIR}/bash_completion" ]] &&
    source "${NVM_DIR}/bash_completion"

[[ -f "${HOME}/.cargo/env" ]] &&
    source "${HOME}/.cargo/env"

if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

