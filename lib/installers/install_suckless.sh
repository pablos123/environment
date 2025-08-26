#!/usr/bin/env bash

function install_suckless() {
    local tool tool_path tool_bin current_tool_version repo_tool_version dependencies
    dependencies=(
        make
        build-essential
        libx11-dev
        libxinerama-dev
        libxft-dev
    )
    sudo apt-get install --yes "${dependencies[@]}"
    for tool in st dwm dmenu; do
        tool_path="${HOME}/.base_repos/${tool}"
        tool_bin="/usr/local/bin/${tool}"

        [[ ! -d "${tool_path}" ]] &&
            git clone --depth 1 "https://git.suckless.org/${tool}" "${tool_path}"


        (
            cd "${tool_path}" || exit 1

            git pull

            current_tool_version=
            if command -v "${tool_bin}" >/dev/null; then
                current_tool_version="$("${tool_bin}" -v 2>&1 | sed "s/${tool}[\- ]//")"
            fi

            repo_tool_version=$(grep 'VERSION =' config.mk | sed 's/VERSION = //')

            if [[ "${repo_tool_version}" == "${current_tool_version}" ]]; then
                echo "${tool} is in the last available version."
            else
                make
                sudo make install
                make clean
                git add .
                git reset --hard
            fi
        )
    done
}

install_suckless
