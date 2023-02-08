# Linux Mint setup

Why Ansible?

Ansible is a programming language build for provisions, beyond that I wanted
to have a nice 'self-documented' code to not forget to do the one billion things that
I have written in one billion different notes when I kill my OS and
install it again, in general is Linux Mint but at least I try to keep it Debian 
based at this point.

## Playbooks

All the playbooks for the setup are in the `plays/` folder:

### `plays/nvim_setup`

Tags:
- build: compile and install neovim latest version.
- config: install the configuration located in the specified repo for the specified user in the specified home.

Run the playbooks with the --ask-become-pass option.

#### Build neovim

```terminal
ansible-playbook -i inv/localhost.ini plays/nvim_setup.yml -t build --ask-become-pass
```

#### Configure neovim

```terminal
ansible-playbook -i inv/localhost.ini plays/nvim_setup.yml -t config --ask-become-pass -e user=<user> -e user_home=<user_home_path> -e nvim_config_repo=<repo_url>
```

or change the defaults to change the variables...
