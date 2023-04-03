#!/bin/bash
#
sudo apt update
sudo apt dist-upgrade
sudo apt autopurge
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
python3 -m pip install --user ansible
git clone git@github.com:pablos123/setup.git "$HOME/setup"
