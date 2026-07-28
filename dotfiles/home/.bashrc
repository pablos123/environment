#!/usr/bin/env bash

if [[ "${-}" != *i* ]]; then
    return
fi

if ((BASH_VERSINFO[0] < 4)); then
    return
fi

if [[ ! "${TERM}" =~ color && ! "${TERM}" =~ kitty ]]; then
    return
fi

{
    shopt -s autocd
    shopt -s dirspell
    shopt -s cdspell
    shopt -s globstar
    # Bookmarks: 'cd' into a variable holding a path from anywhere.
    shopt -s cdable_vars
    shopt -s checkwinsize
    shopt -s histappend
    shopt -s cmdhist
} &>>/dev/null

# !!<space> expands to the previous command instead of waiting for Enter.
bind Space:magic-space

bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "set show-all-if-unmodified on"
bind "set mark-symlinked-directories on"
bind "set colored-stats on"
bind "set colored-completion-prefix on"
bind "set visible-stats on"
# Elide a shared completion prefix once it passes 7 characters.
bind "set completion-prefix-display-length 7"

export VISUAL=/usr/local/bin/nvim
export EDITOR=/usr/local/bin/nvim

export GIT_AUTHOR_NAME=Pablo
export GIT_AUTHOR_EMAIL=pablosaavedra123@gmail.com
export GIT_COMMITTER_NAME=Pablo
export GIT_COMMITTER_EMAIL=pablosaavedra123@gmail.com

if [[ -f "${HOME}/.git-prompt.sh" ]]; then
    source "${HOME}/.git-prompt.sh"
fi

export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM=verbose

# __git_ps1 only emits color from PROMPT_COMMAND, so PS1 is left empty and
# rebuilt on every prompt (see git-prompt.sh).
export PROMPT_COMMAND='__git_ps1 "\[\033[0;34m\]\w\[\033[0m\]" "\n\\\$ "'
export PS1=''
export PROMPT_COMMAND="${PROMPT_COMMAND}; history -a;"

export PROMPT_DIRTRIM=2

export HISTSIZE=500000
export HISTFILESIZE=100000
export HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="exit:ls:history:clear:pwd"
export HISTTIMEFORMAT='%F %T '

alias ls='eza --sort=extension --extended --group-directories-first --classify --git'
alias l='ls'
alias s='ls'
alias sl='ls'
alias ll='ls --long'
alias la='ls --all'
alias lla='ls --all --long'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='cd'

alias :q='exit'
alias :wq='exit'

alias vim='nvim'
alias im='vim'
alias mvi='vim'
alias miv='vim'
alias v='vim'

alias bat='batcat --theme=ansi --paging=never --decorations=never'
alias cat='bat'

alias duf='duf --style=ascii --theme=ansi'
alias df='duf'

alias mkdir='mkdir --parents --verbose'
alias rm='rm --interactive'

alias genc='git add . && git commit --message="genc"'

alias bigdirs='(sudo du --human-readable / | sort --reverse --human-numeric-sort | head --lines=15) 2>/dev/null'
alias myip='printf "External: " && curl --no-progress-meter ifconfig.me && echo && printf "Local: " && hostname -I'
alias sources='grep --color=always -v -E "^#|^ *$" /etc/apt/sources.list /etc/apt/sources.list.d/*'
alias weather='curl wttr.in/rosario'
alias calendar_fact='calendar | head --lines=1 | cowsay -f duck | lolcat'
alias tree='tree --dirsfirst --gitignore --classify --color=always -A'
alias tre='tree'
alias xfe='(xfe . &>/dev/null) & disown'
alias ssh='TERM=xterm-256color ssh'

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

# Home bin must win over /usr/bin: it holds wrappers that shadow real binaries.
if [[ -d "${HOME}/bin" ]]; then
    export PATH="${HOME}/bin:${PATH}"
fi
