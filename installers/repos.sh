#!/bin/bash
#
#
declare -A repos=(
    ["git@github.com:pablos123/dotfiles.git"]="$HOME/dotfiles"
    ["git@github.com:pablos123/bin.git"]="$HOME/bin"
    ["git@github.com:pablos123/notes.git"]="$HOME/notes"
    ["git@github.com:pablos123/.wallpapers.git"]="$HOME/.wallpapers"
    ["git@github.com:pablos123/cinecli.git"]="$HOME/projects/cinecli"
    ["git@github.com:pablos123/dump.git"]="$HOME/projects/dump"
)

for repo in "${!repos[@]}"; do
    if [[ -d "${repos[$repo]}" ]]; then
        pull "$HOME/dotfiles"
        continue
    fi
    git clone "$repo" "${repos[$repo]}"
done
