#!/usr/bin/env bash

export VISUAL="/usr/local/bin/nvim"
export EDITOR="/usr/local/bin/nvim"

export GIT_PS1_SHOWDIRTYSTATE="true"
export GIT_PS1_SHOWSTASHSTATE="true"
export GIT_PS1_SHOWUNTRACKEDFILES="true"
export GIT_PS1_SHOWUPSTREAM="verbose"

export GIT_AUTHOR_NAME="Pablo"
export GIT_AUTHOR_EMAIL="pablosaavedra123@gmail.com"
export GIT_COMMITTER_NAME="Pablo"
export GIT_COMMITTER_EMAIL="pablosaavedra123@gmail.com"

export PS1='\[\e\][0;32m \[\w\] \[\e\][1;33m $(__git_ps1 "(  %s )")\[\e\][0m\n$ '

export REPOS_PATH="${HOME}/repos"

[[ -f "${HOME}/.custom_env_variables" ]] &&
    source "${HOME}/.custom_env_variables"

