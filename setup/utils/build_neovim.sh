#!/bin/bash
#

if [[ ! $(id -u) == 0 ]]; then
    echo -e "\e[1;31mRun as root or with sudo!\e[0m" && exit 1
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

echo -e "Installing dependencies..."
apt install -y "${dependencies[@]}"

echo "Making necessary directories..."
mkdir -p "/opt/nvim" "/opt/nvim/repos/"

echo "Deleting repository direcory..."
rm -rf /opt/nvim/repos/neovim/

echo -e "Cloning repo..."
git clone https://github.com/neovim/neovim /opt/nvim/repos/neovim/

cd /opt/nvim/repos/neovim/ || exit 1

echo -e "Making neovim..."
make CMAKE_BUILD_TYPE=Release

echo -e "Installing neovim..."
make install

echo -e "All done! Neovim installed..."
nvim --version
