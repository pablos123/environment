chrome_installer() {
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo add-apt-repository "deb http://dl.google.com/linux/chrome/deb/ stable main"
    sudo apt update
    sudo apt install -y google-chrome-stable

    dconf write /org/gnome/desktop/interface/color-scheme \'prefer-dark\'
    # Set chrome as the default browser
    xdg-settings set default-web-browser 'google-chrome.desktop'
}
vscode_installer() {
    wget -O './vscode.deb' 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
    sudo apt install -y './vscode.deb'
    rm -f './vscode.deb'
}
wezterm_installer() {
    wget -O './wezterm.deb' 'https://github.com/wez/wezterm/releases/download/20240203-110809-5046fc22/wezterm-20240203-110809-5046fc22.Ubuntu22.04.deb'
    sudo apt install -y './wezterm.deb'
    rm -f './wezterm.deb'
}
dunst_installer() {
    local dependencies
    dependencies=(
      libdbus-1-dev
      libx11-dev
      libxinerama-dev
      libxrandr-dev
      libxss-dev
      libglib2.0-dev
      libpango1.0-dev
      libgtk-3-dev
      libxdg-basedir-dev
      libnotify-dev
    )

    sudo apt install -y "${dependencies[@]}"

    rm -rf "$HOME/.dunst"
    git clone https://github.com/dunst-project/dunst.git "$HOME/.dunst"
    cd "$HOME/.dunst" || exit 1
    make
    sudo make install
}
# https://github.com/junegunn/fzf
fzf_installer() {
    rm -rf "$HOME/.fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    yes | "$HOME/.fzf/install"
}
# https://i3wm.org/
i3_installer() {
    wget -O './i3.deb' 'http://ftp.debian.org/debian/pool/main/i/i3-wm/i3_4.23-1_amd64.deb'
    wget -O './i3-wm.deb' 'http://ftp.debian.org/debian/pool/main/i/i3-wm/i3-wm_4.23-1_amd64.deb'
    sudo apt install './i3-wm.deb'
    sudo apt install './i3.deb'
    rm -f './i3.deb' './i3-wm.deb'
}
repos_installer() {
    local repo
    declare -A repos=(
        ["git@github.com:pablos123/notes.git"]="$HOME/notes"
        ["git@github.com:pablos123/dump.git"]="$HOME/projects/dump"
        ["git@github.com:pablos123/pablos123.github.io.nvim.git"]="$HOME/projects/pablos123.github.io"
    )

    for repo in "${!repos[@]}"; do
        if [[ -d "${repos[$repo]}" ]]; then
            (
                cd "${repos[$repo]}" || exit 1
                git pull
            )
            continue
        fi
        git clone "$repo" "${repos[$repo]}"
    done
    rm -rf "$HOME/.wallpapers"
    mkdir "$HOME/.wallpapers"
    git clone "git@github.com:pablos123/.wallpapers.git" "$HOME/.wallpapers"
}
sys_installers=(
    chrome_installer
    vscode_installer
    wezterm_installer
    dunst_installer
    fzf_installer
    i3_installer
    repos_installer
)
