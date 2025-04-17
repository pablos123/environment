#!/usr/bin/env bash

function obtain_obsidian_version() {
    echo "${1}" | grep --only-matching -E 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1 | sed 's/v//'
}

function install_obsidian() {
    local current_version latest_version current_version_path latest_version_path obsidian_path

    obsidian_path="${HOME}/bin"

    current_version=$(obtain_obsidian_version "$(find "${obsidian_path}" -name "*obsidian_v*")")
    latest_version=$(obtain_obsidian_version "$(curl https://github.com/obsidianmd/obsidian-releases/releases/ 2>/dev/null)")

    current_version_path="${obsidian_path}/obsidian_v${current_version}"
    latest_version_path="${obsidian_path}/obsidian_v${latest_version}"

    if [[ -z "${current_version}" ]] || [[ "${latest_version}" > "${current_version}" ]]; then
        rm -f "${current_version_path}"
        wget -O "${latest_version_path}" "https://github.com/obsidianmd/obsidian-releases/releases/download/v${latest_version}/Obsidian-${latest_version}.AppImage"
    else
        echo "Obsidian is in the latest version: ${latest_version}"
    fi

    chmod +x "${latest_version_path}"
}

# Using nvim for a while
# install_obsidian
