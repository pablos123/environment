#!/usr/bin/env sh
#
# Common
alias ls='eza --sort=extension --extended --group-directories-first --classify --git'
alias l='ls'
alias s='ls'
alias sl='ls'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -al'

alias ..='cd -- ..'
alias ...='cd -- ../..'
alias ....='cd -- ../../..'

alias :q='exit'
alias :wq='exit'

alias vim='nvim'
alias im='vim'
alias mvi='vim'
alias miv='vim'

alias bat='batcat --theme=gruvbox-dark --paging=never --decorations=never'
alias cat='bat'

alias duf='duf --style=ascii --theme=ansi'
alias df='duf'

alias mkdir='mkdir -p -v'
alias rm='rm -i'

alias genc='git add . && git commit -m "genc"'

alias bigdirs='(sudo du -h / | sort -rh | head -n 15) 2>/dev/null'
alias myip='printf "External: " && curl -s ifconfig.me && echo && printf "Local: " && hostname -I'
alias sources='grep --color=always -v -E "^#|^ *$" /etc/apt/sources.list /etc/apt/sources.list.d/*'
alias weather='curl wttr.in/rosario'
alias calendar_fact='calendar | head -n 1 | cowsay -f duck | lolcat'
alias tree='tree --dirsfirst --gitignore -F -C -A'
alias xfe='(xfe . &>> /dev/null) & disown'
