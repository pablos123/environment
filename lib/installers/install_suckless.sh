#!/usr/bin/env bash

function install_suckless() {
    local tool tool_path tool_bin tool_config current_tool_version repo_tool_version dependencies
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
        tool_config="/home/pab/environment/lib/shared/${tool}_config.h"

        [[ ! -d "${tool_path}" ]] &&
            git clone --depth 1 "https://git.suckless.org/${tool}" "${tool_path}"


        (
            cd "${tool_path}" || exit 1

            git pull

            current_tool_version=
            if command -v "${tool_bin}" >/dev/null; then

                current_tool_version="$("${tool_bin}" -v 2>&1 | sed "s@${tool}-@@;s@${tool_bin} @@")"
            fi

            repo_tool_version=$(grep 'VERSION =' config.mk | sed 's/VERSION = //')

            if [[ "${repo_tool_version}" == "${current_tool_version}" ]] && [[ ! "$1" == "-f" ]]; then
                echo "${tool} is in the last available version."
            else
                [[ -s "${tool_config}" ]] &&
                    cp "${tool_config}" ./config.def.h
                make
                sudo make install
                make clean
                git add .
                git reset --hard
            fi
        )
    done
}

install_suckless "$@"
