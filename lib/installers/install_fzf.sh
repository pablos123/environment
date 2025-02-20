#!/usr/bin/env bash

function install_fzf() {
    local fzf_path

    fzf_path="${REPOS_PATH}/fzf"

    [[ ! -d "${fzf_path}" ]] &&
        git clone --depth 1 https://github.com/junegunn/fzf.git "${fzf_path}"

    cd "${fzf_path}"

    git add .
    git reset --hard
    git pull

    (yes | ./install) >/dev/null 2>&1
}

install_fzf
