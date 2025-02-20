#!/usr/bin/env sh

[ -n "${BASH_VERSION}" ] && [ -f "${HOME}/.bashrc" ] &&
    . "${HOME}/.bashrc"

[ -d "${HOME}/bin" ] &&
   PATH="${HOME}/bin:${PATH}"

[ -d "${HOME}/.local/bin" ] &&
  PATH="${HOME}/.local/bin:${PATH}"


[ -d "${HOME}/.cargo/bin" ] &&
    PATH="${HOME}/.cargo/bin:${PATH}"

[ -d "${HOME}/go/bin" ] &&
    PATH="${HOME}/go/bin:${PATH}"

[ -d "${HOME}/environment/bin" ] &&
    PATH="${HOME}/environment/bin:${PATH}"

[ -d "${HOME}/.pyenv" ] &&
    PATH="${HOME}/.pyenv:${PATH}"

[ -f /usr/share/bash-completion/bash_completion ] &&
    . /usr/share/bash-completion/bash_completion

