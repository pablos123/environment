#!/bin/bash
#

if [[ ! $(id -u) == 0 ]]; then
    echo -e "${BRED}Run as root or with sudo!${CRESET}" && exit 1
fi

dependencies=(
ninja-build
gettext
libtool
libtool-bin
autoconf
automake
cmake
g++
pkg-config
unzip
curl
doxygen
)

echo -e "\e[5;35mInstalling dependencies...\e[0m"
apt install -y "${dependencies[@]}" > /dev/null

echo "Making necessary directories..."
mkdir -p "/opt/nvim" "/opt/nvim/repos/"

echo "Deleting repository direcory..."
rm -rf "/opt/nvim/repos/neovim/"

echo -e "\e[5;35mCloning repo...\e[0m"
git clone "https://github.com/neovim/neovim" /opt/nvim/repos/neovim/

cd "/opt/nvim/repos/neovim/" || exit 1

echo -e "\e[5;35mMaking neovim...\e[0m"
make CMAKE_BUILD_TYPE=Release > /dev/null

echo -e "\e[5;35mInstalling neovim...\e[0m"
make install > /dev/null

echo -e "\e[1;32mAll done! Neovim installed...\e[0m"
nvim --version

