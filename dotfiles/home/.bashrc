#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] &&
    return

shopt -s direxpand
shopt -s autocd

source "${HOME}/.bash_variables"
source "${HOME}/.git-prompt.sh"
source "${HOME}/.bash_aliases"

[[ -f /usr/share/bash-completion/bash_completion ]] &&
    source /usr/share/bash-completion/bash_completion

[[ -f "${HOME}/.fzf.bash" ]] &&
    source ${HOME}/.fzf.bash

[[ -f "${HOME}/.bashrc_custom" ]] &&
    source "${HOME}/.bashrc_custom"

export NVM_DIR="${HOME}/.nvm"

[[ -f "${NVM_DIR}/nvm.sh" ]] &&
    source "${NVM_DIR}/nvm.sh"

[[ -f "${NVM_DIR}/bash_completion" ]] &&
    source "${NVM_DIR}/bash_completion"

[[ -f "${HOME}/.cargo/env" ]] &&
    source "${HOME}/.cargo/env"

export PYENV_ROOT="${HOME}/.pyenv"

[[ -d ${PYENV_ROOT}/bin ]] &&
    export PATH="${PYENV_ROOT}/bin:${PATH}"

if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

