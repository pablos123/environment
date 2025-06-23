#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] &&
    return

shopt -s direxpand
shopt -s autocd

source "${HOME}/environment/lib/aliases.sh"
source "${HOME}/environment/lib/git_prompt.sh"

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

[[ -f /usr/share/bash-completion/bash_completion ]] &&
    source /usr/share/bash-completion/bash_completion

[[ -f "${HOME}/.fzf.bash" ]] &&
    source ${HOME}/.fzf.bash

[[ -f "${HOME}/.bashrc_custom" ]] &&
    source "${HOME}/.bashrc_custom"

[[ -f "${HOME}/.cargo/env" ]] &&
    source "${HOME}/.cargo/env"

# pyenv
export PYENV_ROOT="${HOME}/.pyenv"
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
