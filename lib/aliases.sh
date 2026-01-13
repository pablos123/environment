#!/usr/bin/env sh
#
# Common
alias ls='eza --sort=extension --extended --group-directories-first --classify --git'
alias l='ls'
alias s='ls'
alias sl='ls'
alias ll='ls --long'
alias la='ls --all'
alias lla='ls --all --long'

alias ..='cd -- ..'
alias ...='cd -- ../..'
alias ....='cd -- ../../..'
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

alias genc='git add . && git commit -m "genc"'

alias bigdirs='(sudo du --human-readable / | sort --reverse --human-numeric-sort | head --lines=15) 2>/dev/null'
alias myip='printf "External: " && curl --silent ifconfig.me && echo && printf "Local: " && hostname -I'
alias sources='grep --color=always -v -E -- "^#|^ *$" /etc/apt/sources.list /etc/apt/sources.list.d/*'
alias weather='curl wttr.in/rosario'
alias calendar_fact='calendar | head --lines=1 | cowsay -f duck | lolcat'
alias tree='tree --dirsfirst --gitignore -F -C -A'
alias tre='tree'
alias xfe='(xfe . &> /dev/null) & disown'
alias ssh='TERM=xterm-256color ssh'
