#!/usr/bin/env bash

function install_suckless() {
    local tool tool_path current_tool_version current_tool_version repo_tool_version dependencies
    dependencies=(
        make
        build-essential
        libx11-dev
        libxinerama-dev
        libxft-dev
    )
    sudo apt-get install --yes "${dependencies[@]}"
    for tool in dwm dmenu st; do
        tool_path="${REPOS_PATH}/${tool}"

        [[ ! -d "${tool_path}" ]] &&
            git clone "https://git.suckless.org/${tool}" "${tool_path}"

        cd "${tool_path}" || exit 1

        git pull

        repo_tool_version=$(grep 'VERSION =' config.mk | sed 's/VERSION = //')
        if which "${tool}" >/dev/null; then
            current_tool_version="$("${tool}" -v 2>&1 | sed "s/${tool}[\- ]//")"
            if [[ "${repo_tool_version}" == "${current_tool_version}" ]]; then
                echo "${tool} is in the last available version."
                continue
            fi
        fi

        make
        sudo make install
        make clean
        git add .
        git reset --hard
    done
}

install_suckless
