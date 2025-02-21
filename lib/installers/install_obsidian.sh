#!/usr/bin/env bash

function obtain_obsidian_version() {
    echo "${1}" | grep --only-matching -E 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1 | sed 's/v//'
}

function install_obsidian() {
    local current_version latest_version obsidian_path

    latest_version=$(obtain_obsidian_version "$(curl https://github.com/obsidianmd/obsidian-releases/releases/ 2>/dev/null)")
    current_version=$(obtain_obsidian_version "$(find "${HOME}/bin/" -name "*obsidianv*")")

    if [[ -z "${current_version}" ]] || [[ "${latest_version}" > "${current_version}" ]]; then
        rm -f "${HOME}/bin/obsidianv${current_version}"
        wget -O "${HOME}/bin/obsidianv${latest_version}" "https://github.com/obsidianmd/obsidian-releases/releases/download/v${latest_version}/Obsidian-${latest_version}.AppImage"
    else
        echo "Obsidian is in the latest version: ${latest_version}"
    fi

    chmod +x "${HOME}/bin/obsidianv${latest_version}"
}

install_obsidian
