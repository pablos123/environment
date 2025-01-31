#!/bin/bash

# my_user=pab


# Enter with root
# Utils
# https://dwm.suckless.org/
# https://tools.suckless.org/dmenu/
# https://wiki.debian.org/NetworkManager

# packages=(
#     sudo
#     git
#     vim
#     xorg
#
#     make
#     build-essential
#     libx11-dev
#     libxinerama-dev
#     libxft-dev
#     network-manager
#     pulseaudio
# )
# apt install -y "${packages[@]}"

# Add user to the sudo group
# usermod -aG sudo "${my_user}"
# exit

# USER ------------------------------------
original_path="$(pwd)"

repos_path="${HOME}/repos"
mkdir -p "${repos_path}"

function setup_suckless() {
    local tool tool_path tool_version current_tool_version repo_tool_version
    for tool in dwm dmenu; do
        tool_path="${repos_path}/${tool}"

        [[ ! -d "${tool_path}" ]] && \
            git clone "https://git.suckless.org/${tool}" "${tool_path}"

        cd "${tool_path}"
        git pull

        repo_tool_version=$(grep 'VERSION =' config.mk | sed 's/VERSION = //')
        if which "${tool}" >/dev/null; then
            current_tool_version="$("${tool}" -v 2>&1 | sed "s/${tool}\-//")"
            if [[ "${repo_tool_version}" == "${current_tool_version}" ]]; then
                echo "${tool} is in the last available version."
                continue
            fi
        fi

        sed -i 's@^PREFIX.*@PREFIX = $(HOME)/.local@' config.mk
        make
        make install
        make clean
        git checkout .
    done
}

setup_suckless

cd "${original_path}"
