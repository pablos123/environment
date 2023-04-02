#!/bin/bash
#
# https://github.com/fairyglade/ly

git clone --recurse-submodules https://github.com/fairyglade/ly "$HOME/.ly"

cd "$HOME/.ly" || exit 1
make
sudo make install installsystemd
sudo systemctl enable ly.service
# Disable lightdm
sudo systemctl disable lightdm
