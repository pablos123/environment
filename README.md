# `#!/bin/bash`
Pure bash setup.

My environment is very stable and I used it for almost 3 years now.
Never the less I'm always changing, adding or optimizing somehing.
Before I used Ansible to setup my machine but now I don't think Ansible is the right tools: I want dynamism and I walways execute this in one host.
## Initial Setup
```
cd "$HOME/environment/setup"
sudo ./utils/build_neovim.sh && ./setup.sh
```
## Environment
### Upgrade system
```
upgrade_system
```
### Build Neovim
```
build_nvim
```
### Used in
```
# Linux Mint 21.2

# Linux Mint 21.1
```
