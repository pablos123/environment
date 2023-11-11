#!/bin/bash
version='1.2.1'
wget -O './myxer.deb' "https://github.com/VixenUtils/Myxer/releases/download/$version/Myxer.deb"
sudo apt install -y './myxer.deb'
rm -f './myxer.deb'
