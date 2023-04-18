#!/bin/bash
#
# My own corne keyboard
# #################################################################################################
# Build
# #################################################################################################
# https://github.com/foostan/crkbd
# Only build problem:
# https://www.reddit.com/r/olkb/comments/bdvs7i/crkbd_corne_helidox_oled_screens_not_working/
#
# I HAVE V2 pcb so the official v2 guide is: https://github.com/foostan/crkbd/blob/main/corne-cherry/doc/v2/buildguide_en.md
# Unofficial incredible good guide https://devpew.com/blog/corne-eng/
# Unofficial incredible good guide https://josef-adamcik.cz/electronics/in-search-of-the-best-custom-keyboard-layout.html
#
# #################################################################################################
# Firmware
# #################################################################################################
# Bash script to not do https://github.com/foostan/crkbd/blob/main/doc/firmware_en.md manually
#
# QMK (firmware)
# https://docs.qmk.fm/#/newbs_getting_started
#

python3 -m pip install --user qmk
qmk setup

# ***
# Get the firmaware manually if you want so you can flash directly with `qmk --flash`
# Just type: `qmk --flash <hex files downloaded>` and reset the keyboard to bootloader mode.
#
# Getting firwares:
# https://www.caniusevia.com/docs/download_firmware#0
# We are interested in crkbd_rev1_via.hex, I don't know about the other crkbd firmware.
# From github:
# https://raw.githubusercontent.com/foostan/qmk_firmware-hex/main/.build/crkbd_rev1_via.hex
# I checked the md5sum of both of the files they're different mmm... I can't get VIA tu work.
# I read that IS BETTER TO DO THE INSTALLING WITH ONLY ONW SIDE CONNECTED, i.e not using the TRRS cable.
# Compiling the firmware
#
cd "$HOME/qmk_firmware" && make crkbd:via

# Flashing the micro
#
cd "$HOME/qmk_firmware" && make crkbd:via:avrdude

# YOU NEED TO DO THIS FOR THE OTHER PRO MICRO CHIP TOO
# IMPORTANT!!! You need to connect the usb cable on the left side of the cornekeyboard.
# Weird shit happen if you connect it to the right side.

# If this error appears:
# Waiting for /dev/ttyACM0 to become writable.
# FIRST try again a few times!
# Multiple erorrs can happen
#
#
# If still happen: Change permissions, it means that you don't have write permission on /dev/<something>
# https://www.reddit.com/r/olkb/comments/pwhthj/stuck_on_waiting_for_devttyamc0_to_become_writable/
#
# sudo chmod /dev/tty...
#
# #################################################################################################
# Keymaps
# #################################################################################################
#
# Install VIA
# https://github.com/the-via/releases/releases/
# Play with the keymap:D
#
# Linux codes recognized by the X Windows System:
#
# `xev` # (X events)
#
# ***
# I keep getting the errors:
#
# 23:44:29.861
# Failed to write the report.
# Device: foostan Corne
# Vid: 0x4653
# Pid: 0x0001
# 23:44:29.887
#
# Received invalid protocol version from device
# Device: foostan Corne
# Vid: 0x4653
# Pid: 0x0001
