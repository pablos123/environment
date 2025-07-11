#!/usr/bin/env bash

function install_eza() {
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --yes --dearmor -o /etc/apt/keyrings/gierens.gpg
    (echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg arch=amd64] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list) > /dev/null
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install --yes eza
}

install_eza
