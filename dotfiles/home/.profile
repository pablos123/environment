#!/usr/bin/env sh

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

[ -d "${PYENV_ROOT}/bin" ] &&
    PATH="${PYENV_ROOT}/bin:${PATH}"

[ "$(tty)" = "/dev/tty1" ] && command -v startx && startx
