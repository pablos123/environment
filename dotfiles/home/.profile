#!/usr/bin/env sh

if [ -n "${BASH_VERSION}" ]; then
    [ -f "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"
fi

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

if [ -d "${HOME}/.pyenv" ]; then
    PATH="${HOME}/.pyenv:${PATH}"
fi
