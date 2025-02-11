#!/usr/bin/env bash

if [[ "$(whoami)" != "root" ]]; then
    echo "You can only run this script with root."
    exit 1
fi

apt install -y sudo
usermod -aG sudo pab

