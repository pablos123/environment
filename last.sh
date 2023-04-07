#!/bin/bash
#
sudo apt autopurge
sudo systemctl stop lightdm.service 
sudo reboot
