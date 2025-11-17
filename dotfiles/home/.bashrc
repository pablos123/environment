#!/usr/bin/env bash

# If not running interactively, don't do anything.
[[ $- != *i* ]] &&
    return

# If bash's version is bad don't do anything.
((BASH_VERSINFO[0] < 4)) &&
    return

# Return if not the terminal cannot use colors.
[[ ! "${TERM}" =~ color ]] &&
    return

if command -v tmux &>>/dev/null &&
    [[ ! "${TERM}" =~ screen ]] &&
    [[ ! "${TERM}" =~ tmux ]] &&
    [[ -z "${TMUX}" ]]; then
    # Tell tmux to assume 256 colors with the -2 option.
    exec tmux -2 new-session -A -s forest
fi

# SHELL OPTIONS
# ---------------------------------------------------------------------
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
# ---------------------------------------------------------------------

# ENV
# ---------------------------------------------------------------------
export VISUAL=/usr/local/bin/nvim
export EDITOR=/usr/local/bin/nvim

export GIT_AUTHOR_NAME=Pablo
export GIT_AUTHOR_EMAIL=pablosaavedra123@gmail.com
export GIT_COMMITTER_NAME=Pablo
export GIT_COMMITTER_EMAIL=pablosaavedra123@gmail.com

# PS1
source "${HOME}/environment/lib/shared/git_prompt.sh"

export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM=verbose

# Use PROMPT_COMMAND (not PS1) to get color output (see git-prompt.sh for more)
export PROMPT_COMMAND='__git_ps1 "\[\033[0;34m\]\w\[\033[0m\]" "\n\\\$ "'
export PS1=''

# Automatically trim long paths in the prompt.
export PROMPT_DIRTRIM=2

# HISTORY

# Append to history after finishing any command.
export PROMPT_COMMAND="${PROMPT_COMMAND}; history -a;"

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
# ---------------------------------------------------------------------

# SOURCES
# ---------------------------------------------------------------------
source "${HOME}/environment/lib/aliases.sh"
[[ -f "${HOME}/.bashrc_custom" ]] &&
    source "${HOME}/.bashrc_custom"

export PYENV_ROOT="${HOME}/.pyenv"
export NVM_DIR=/opt/nvm

[[ -f /usr/share/bash-completion/bash_completion ]] &&
    source /usr/share/bash-completion/bash_completion

[[ -f "${HOME}/.fzf.bash" ]] &&
    source ${HOME}/.fzf.bash

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
# ---------------------------------------------------------------------
