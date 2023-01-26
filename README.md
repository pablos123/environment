# Linux Mint setup

## Playbooks

All the playbooks for the setup are in the `play/` folder:

### `plays/nvim_setup`

tags:
- build: compile and install neovim latest version.
- config: install the configuration located the specified repo for the specified user in the specified home.

Run the playbooks with the --ask-become-pass option.

#### Build neovim

`ansible-playbook -i inv/localhost.ini plays/nvim_setup.yml -t build --ask-become-pass`

#### Configure neovim

`ansible-playbook -i inv/localhost.ini plays/nvim_setup.yml -t config --ask-become-pass -e user=<user> -e user_home=<user_home_path> -e nvim_config_repo=<repo_url>`

or change the defaults to change the variables...
