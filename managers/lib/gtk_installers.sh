#!/usr/bin/env bash
# After defining the function add it to the installers list
# Each function has to be idempotent and
# needs to install the theme in $1

capitaine_cursor() {
    if [[ ! -d "$HOME/.icons/Capitaine Cursors" ]]; then
        wget -O "/tmp/capitaine.zip" "https://github.com/sainnhe/capitaine-cursors/releases/download/r5/Linux.zip"
        unzip -o "/tmp/capitaine.zip" -d "$HOME/.icons"
    fi
}
gruvbox_icons() {
    if [[ ! -d "$HOME/.icons/Gruvbox-Plus-Dark" ]]; then
        git clone "https://github.com/SylEleuth/gruvbox-plus-icon-pack.git" "/tmp/gruvbox_icons"
        mv "/tmp/gruvbox_icons/Gruvbox-Plus-Dark" "$HOME/.icons"
    fi
}
suru_icons() {
    if [[ ! -d "$HOME/.icons/Suru++" ]]; then
        (wget -qO- https://raw.githubusercontent.com/gusbemacbe/suru-plus/master/install.sh | env DESTDIR="$HOME/.icons" sh) >/dev/null
    fi
}
fausto_themes() {
    local repos
    install_fausto_theme() {
        local name repo_dir
        name="$(echo "$1" | sed 's/.*com\/.*\///g')"
        echo "Installing $name..."
        repo_dir="/tmp/repos/$name"
        if [[ ! -d $repo_dir ]]; then
            git clone "$1" "$repo_dir"
        fi
        cp -r "$repo_dir" "$HOME/.themes"
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

cinnamon_themes() {
    local themes icons theme icon
    themes=(
        HighContrast
    )
    icons=(
        HighContrast
        Adwaita
    )

    for theme in "${themes[@]}"; do
        cp -r "/usr/share/themes/$theme" "$HOME/.themes"
    done

    for icon in "${icons[@]}"; do
        cp -r "/usr/share/icons/$icon" "$HOME/.icons"
    done
}

gtk_installers=(
    capitaine_cursor
    gruvbox_icons
    suru_icons
    fausto_themes
    cinnamon_themes
)
