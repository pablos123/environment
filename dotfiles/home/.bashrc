# Bash interactive shell configuration. `set -Eeuo pipefail` is deliberately
# omitted because this file is sourced into the interactive shell.

# If not running interactively, don't do anything.
if [[ "$-" != *i* ]]; then
    return
fi

# If bash's version is bad don't do anything.
if ((BASH_VERSINFO[0] < 4)); then
    return
fi

# Return if the terminal cannot use colors.
if [[ ! "${TERM}" =~ color && ! "${TERM}" =~ kitty ]]; then
    return
fi

# Vim terminal buffer sets this value as xterm-256color and the buffer
# opens tmux.
# if [[ ! "${TERM}" =~ kitty && ! "${TERM}" =~ screen && ! "${TERM}" =~ tmux && -z "${TMUX}" ]]; then
#     if command -v tmux &>/dev/null; then
#         # Tell tmux to assume 256 colors with the -2 option.
#         exec tmux -2 new-session -A -s forest
#     fi
# fi

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

export VISUAL=/usr/local/bin/nvim
export EDITOR=/usr/local/bin/nvim

export GIT_AUTHOR_NAME=Pablo
export GIT_AUTHOR_EMAIL=pablosaavedra123@gmail.com
export GIT_COMMITTER_NAME=Pablo
export GIT_COMMITTER_EMAIL=pablosaavedra123@gmail.com

# PS1
if [[ -f "${HOME}/.git-prompt.sh" ]]; then
    source "${HOME}/.git-prompt.sh"
fi

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

source "${HOME}/environment/lib/aliases.bash"

if [[ -f "${HOME}/.bashrc_custom" ]]; then
    source "${HOME}/.bashrc_custom"
fi

export PYENV_ROOT="${HOME}/.pyenv"
export NVM_DIR="${HOME}/.nvm"

if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

if [[ -f "${HOME}/.fzf.bash" ]]; then
    source "${HOME}/.fzf.bash"
fi

if [[ -f "${HOME}/.cargo/env" ]]; then
    source "${HOME}/.cargo/env"
fi

if [[ -d "${PYENV_ROOT}/bin" && ":${PATH}:" != *":${PYENV_ROOT}/bin:"* ]]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
fi

if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

if [[ -s "${NVM_DIR}/nvm.sh" ]]; then
    source "${NVM_DIR}/nvm.sh"
fi

if [[ -s "${NVM_DIR}/bash_completion" ]]; then
    source "${NVM_DIR}/bash_completion"
fi

if [[ -f "${HOME}/.ghcup/env" ]]; then
    source "${HOME}/.ghcup/env"
fi

if [[ -d "${HOME}/go/bin" ]]; then
    export PATH="${HOME}/go/bin:${PATH}"
fi

# Force home bin directory first for doing wrappers.
if [[ -d "${HOME}/bin" ]]; then
    export PATH="${HOME}/bin:${PATH}"
fi
