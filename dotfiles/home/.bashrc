#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] &&
    return

# # Bootstrap tmux
# command -v tmux >/dev/null 2>&1 &&
#     [[ ! "${TERM}" =~ screen ]] &&
#     [[ ! "${TERM}" =~ tmux ]] &&
#     [[ -z "${TMUX}" ]] &&
#   exec tmux

shopt -s direxpand
shopt -s autocd

source "${HOME}/environment/lib/env_variables.sh"
source "${HOME}/environment/lib/aliases.sh"
source "${HOME}/environment/lib/bash_functions.sh"
source "${HOME}/environment/lib/git_prompt.sh"

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

