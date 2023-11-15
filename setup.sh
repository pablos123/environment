#!/bin/bash
#
#
if [[ ! $(pwd) == "$HOME/environment" ]]; then
    echo "Execute this script inside $HOME/environment/ directory"
fi

sudo apt update
sudo apt full-upgrade
sudo apt autopurge

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user

source "$HOME/environment/utils/packages.sh"
sudo apt install -y "${apt_packages[@]}"
sudo flatpak install -y flathub "${flatpak_packages[@]}"
pip install -y "${pip_packages[@]}"

"$HOME/environment/utils/directories.sh"

for installer in "$HOME/environment/installers/"*; do
    "$HOME/environment/installers/$installer"
    cd "$HOME/environment/" || exit 1
done

for config in "$HOME/environment/configs/"*; do
    "$HOME/environment/configs/$config"
done

"$HOME/environment/utils/clean.sh"

echo "Done! Remember to reboot your pc"
