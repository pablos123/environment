#!/usr/bin/env bash

if [[ "$(whoami)" != "root" ]]; then
    echo "You can only run this script with root."
fi

apt install -y sudo
usermod -aG sudo pab

