#!/bin/bash
sudo apt install python3-venv
python3 -m pip install --user pipx && python3 -m pipx ensurepath
pipx install git+https://github.com/pablos123/cinecli.git
