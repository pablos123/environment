#!/bin/bash
#
mkdir -p ~/.local/etc/ ~/.local/etc/spool/
touch ~/.local/etc/anacrontab

task="""
SHELL=/bin/sh
RANDOM_DELAY=5

#Cinecli database population
# period in days   delay in minutes   job-identifier   command
10    1    cinecli.populate   cinecli database --silent populate
"""

echo "$task" > ~/.local/etc/anacrontab

sudo apt install python3-venv
python3 -m pip install --user pipx && python3 -m pipx ensurepath
pipx install git+https://github.com/pablos123/cinecli.git
