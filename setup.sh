#!/bin/bash
#
#
if [[ ! $(pwd) == "$HOME/environment" ]]; then
    echo "Execute this script inside $HOME/environment/ directory"
fi

sudo apt update
sudo apt full-upgrade -y
sudo apt autopurge -y

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
rm -f ./get-pip.py

source "$HOME/environment/utils/packages.sh"
sudo apt install -y "${apt_packages[@]}"
sudo flatpak install -y flathub "${flatpak_packages[@]}"
pip install -y "${pip_packages[@]}"

"$HOME/environment/utils/directories.sh"

for installer in "$HOME/environment/installers/"*; do
    "$installer"
    cd "$HOME/environment/" || exit 1
done

for config in "$HOME/environment/configs/"*; do
    "$config"
    cd "$HOME/environment/" || exit 1
done

sudo apt purge -y steam wine
sudo apt autopurge -y

rm -f "$HOME/.cache/dmenu_run"
rm -f "$HOME/dmenu_cache"

echo "Done! Remember to reboot your pc"
