#!/bin/bash
#
#
if [[ ! $(pwd) == "$HOME/environment/setup" ]]; then
    echo "Execute this script inside $HOME/environment/setup directory!"
    exit 1
fi

set -e

sudo apt update
sudo apt full-upgrade -y
sudo apt autopurge -y

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
rm -f ./get-pip.py

source "$HOME/environment/setup/utils/packages.sh"
sudo apt install -y "${apt_packages[@]}"
sudo flatpak install -y flathub "${flatpak_packages[@]}"
pip install "${pip_packages[@]}"
cargo install "${cargo_packages[@]}"

"$HOME/environment/setup/utils/make_directories.sh"

for installer in "$HOME/environment/setup/installers/"*; do
    "$installer"
    cd "$HOME/environment/setup/" || exit 1
done

"$HOME/environment/setup/utils/dotfiles.sh"

sudo apt purge -y steam wine
sudo apt autopurge -y

rm -f "$HOME/.cache/dmenu_run"
rm -f "$HOME/dmenu_cache"

echo "Done! Remember to reboot your pc"
