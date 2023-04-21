#!/bin/bash
rm -rf "$HOME/.noneo"
git clone 'https://github.com/pablos123/noneo' "$HOME/.noneo"
cd "$HOME/.noneo/" && ./install.sh
