#!/bin/bash
# After defining the function add it to the installers list
# Each function has to be idempotent and
# needs to install the theme in $1

capitaine_cursor() {
    if [[ ! -f "/tmp/capitaine.zip" ]]; then
        wget -O "/tmp/capitaine.zip" "https://github.com/sainnhe/capitaine-cursors/releases/download/r5/Linux.zip"
    fi
    unzip -o "/tmp/capitaine.zip" -d "$HOME/.icons"
}
gruvbox_icons() {
    if [[ ! -d "/tmp/gruvbox_icons" ]]; then
        git clone "https://github.com/SylEleuth/gruvbox-plus-icon-pack.git" "/tmp/gruvbox_icons"
    fi
    cp -rv "/tmp/gruvbox_icons/Gruvbox-Plus-Dark" "$HOME/.icons"
}
suru_icons() {
    wget -qO- https://raw.githubusercontent.com/gusbemacbe/suru-plus/master/install.sh | env DESTDIR="$HOME/.icons" sh
}
fausto_themes() {
    local repos
	install_fausto_theme() {
		local name repo_dir
		name="$(echo "$1" | sed 's/.*com\/.*\///g')"
		repo_dir="/tmp/repos/$name"
		if [[ ! -d $repo_dir ]]; then
			git clone "$1" "$repo_dir"
		fi
		cp -r "$repo_dir/themes/"* "$HOME/.themes"
	}
	mkdir -p "/tmp/repos"
	repos=(
		"https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme"
		"https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme"
		"https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme"
	)
	for repo in "${repos[@]}"; do
		install_fausto_theme "$repo"
	done
}

installers=(
    capitaine_cursor
    gruvbox_icons
    suru_icons
    fausto_themes
)
