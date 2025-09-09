#!/usr/bin/env bash

# If not running interactively, don't do anything.
[[ $- != *i* ]] &&
    return

# If bash's version is bad don't do anything.
((BASH_VERSINFO[0] < 4)) &&
    return

if command -v tmux &>>/dev/null &&
    [[ ! "${TERM}" =~ screen ]] &&
    [[ ! "${TERM}" =~ tmux ]] &&
    [[ -z "${TMUX}" ]]; then
    # Tell tmux to assume 256 colors with the -2 option.
    exec tmux -2 new-session -A -s forest
fi

{

# Prepend cd to directory names automatically.
shopt -s autocd

# Correct spelling errors during tab-completion.
shopt -s dirspell

# Correct spelling errors in arguments supplied to cd.
shopt -s cdspell

# Turn on recursive globbing (enables ** to recurse all directories).
shopt -s globstar

# This allows you to bookmark your favorite places across the file system.
# Define a variable containing a path and you will be able to cd into it regardless of the directory you're in.
shopt -s cdable_vars

# Update window size after every command.
shopt -s checkwinsize

# Append to the history file, don't overwrite.
shopt -s histappend

# Save multi-line commands as one command in the history.
shopt -s cmdhist

} &>>/dev/null

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command.
bind Space:magic-space

# Perform file completion in a case insensitive fashion.
bind "set completion-ignore-case on"

# Display matches for ambiguous patterns at first tab press.
bind "set show-all-if-ambiguous on"
bind "set show-all-if-unmodified on"

# Immediately add a trailing slash when autocompleting symlinks to directories.
bind "set mark-symlinked-directories on"

# Prettier completitions
bind "set colored-stats on"
bind "set colored-completion-prefix on"
bind "set visible-stats on"
# The maximum length in characters of the common prefix of a list of possible completions that is displayed without modification.
bind "set completion-prefix-display-length 7"

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

export PS1='\[\e\][0;32m\[\w\] \[\e\][1;33m $(__git_ps1 "( %s )")\[\e\][0m\n$ '

# Append to history after finishing any command.
export PROMPT_COMMAND='history -a'

# Automatically trim long paths in the prompt.
export PROMPT_DIRTRIM=2

# Big history.
export HISTSIZE=500000
export HISTFILESIZE=100000

# Avoid duplicate entries.
export HISTCONTROL="erasedups:ignoreboth"

# Don't record some commands.
export HISTIGNORE="exit:ls:history:clear:pwd"

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
export HISTTIMEFORMAT='%F %T '

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
