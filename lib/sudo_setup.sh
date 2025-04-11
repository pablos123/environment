#!/usr/bin/env bash

if [[ "$(whoami)" != "root" ]]; then
    echo "You can only run this script with root."
    exit 1
fi

apt-get install --yes sudo git
usermod -aG sudo pab

