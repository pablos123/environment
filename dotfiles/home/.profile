#!/usr/bin/env sh

if [ -d "${HOME}/bin" ]; then
    PATH="${HOME}/bin:${PATH}"
fi

if [ -d "${HOME}/.local/bin" ]; then
    PATH="${HOME}/.local/bin:${PATH}"
fi

if [ -d "${HOME}/.cargo/bin" ]; then
    PATH="${HOME}/.cargo/bin:${PATH}"
fi

if [ -d "${HOME}/go/bin" ]; then
    PATH="${HOME}/go/bin:${PATH}"
fi

if [ -d "${HOME}/environment/bin" ]; then
    PATH="${HOME}/environment/bin:${PATH}"
fi

export PATH

if [ "$(tty)" = "/dev/tty1" ] && [ -z "${DISPLAY}" ] && command -v startx >/dev/null; then
    startx
fi
