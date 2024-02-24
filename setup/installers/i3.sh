#!/bin/bash
#
# Please just put i3 4.22 in the official Mint repo
# https://i3wm.org/
wget -O './i3.deb' 'http://ftp.debian.org/debian/pool/main/i/i3-wm/i3_4.23-1_amd64.deb'
wget -O './i3-wm.deb' 'http://ftp.debian.org/debian/pool/main/i/i3-wm/i3-wm_4.23-1_amd64.deb'
sudo apt install './i3-wm.deb'
sudo apt install './i3.deb'
rm -f './i3.deb' './i3-wm.deb'
