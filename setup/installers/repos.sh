#!/bin/bash
#
#
declare -A repos=(
    ["git@github.com:pablos123/dotfiles.git"]="$HOME/dotfiles"
    ["git@github.com:pablos123/notes.git"]="$HOME/notes"
    ["git@github.com:pablos123/.wallpapers.git"]="$HOME/.wallpapers"
    ["git@github.com:pablos123/cinecli.git"]="$HOME/projects/cinecli"
    ["git@github.com:pablos123/dump.git"]="$HOME/projects/dump"
    ["git@github.com:pablos123/pablos123.github.io.nvim.git"]="$HOME/projects/pablos123.github.io"
)

for repo in "${!repos[@]}"; do
    if [[ -d "${repos[$repo]}" ]]; then
        cd "${repos[$repo]}" || exit 1
        git pull
        continue
    fi
    git clone "$repo" "${repos[$repo]}"
done
