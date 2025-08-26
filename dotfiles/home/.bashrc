#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] &&
    return

command -v tmux >/dev/null 2>&1 &&
    [[ ! "${TERM}" =~ screen ]] &&
    [[ ! "${TERM}" =~ tmux ]] &&
    [[ -z "${TMUX}" ]] &&
  exec tmux

shopt -s direxpand
shopt -s autocd

source "${HOME}/environment/lib/aliases.sh"
source "${HOME}/environment/lib/git_prompt.sh"

# Env
export VISUAL=/usr/local/bin/nvim
export EDITOR=/usr/local/bin/nvim

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM=verbose

export GIT_AUTHOR_NAME=Pablo
export GIT_AUTHOR_EMAIL=pablosaavedra123@gmail.com
export GIT_COMMITTER_NAME=Pablo
export GIT_COMMITTER_EMAIL=pablosaavedra123@gmail.com

export PS1='\[\e\][0;32m \[\w\] \[\e\][1;33m $(__git_ps1 "(  %s )")\[\e\][0m\n$ '

export PROMPT_COMMAND='history -a'

export PYENV_ROOT="${HOME}/.pyenv"

export NVM_DIR="${HOME}/.nvm"

[[ -f /usr/share/bash-completion/bash_completion ]] &&
    source /usr/share/bash-completion/bash_completion

[[ -f "${HOME}/.fzf.bash" ]] &&
    source ${HOME}/.fzf.bash

[[ -f "${HOME}/.bashrc_custom" ]] &&
    source "${HOME}/.bashrc_custom"

[[ -f "${HOME}/.cargo/env" ]] &&
    source "${HOME}/.cargo/env"

[[ -d "${PYENV_ROOT}"/bin ]] && [[ ":${PATH}:" != *":${PYENV_ROOT}/bin:"* ]] &&
    export PATH="${PYENV_ROOT}/bin:${PATH}"
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

[[ -s "${NVM_DIR}/nvm.sh" ]] &&
    source "${NVM_DIR}/nvm.sh"
[[ -s "${NVM_DIR}/bash_completion" ]] &&
    source "${NVM_DIR}/bash_completion"
