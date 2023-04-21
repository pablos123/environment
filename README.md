# Linux Mint setup

Why Ansible?

Ansible is a programming language build for provisions, beyond that I wanted to have a nice 'self-documented' code to build my environment.
In general is Linux Mint but at least I try to keep it Ubuntu/Debian based at this point.

## Playbooks

Run the playbooks with the `--ask-become-pass` option.

### `nvim_setup`

Tags:
- `build`: compile and install neovim latest version.
- `config`: install the configuration located in the specified repo for the specified user in the specified home.

#### Build neovim

```
ansible-playbook plays/nvim_setup.yml -t build --ask-become-pass
```

#### Configure neovim

```
ansible-playbook plays/nvim_setup.yml -t config --ask-become-pass
```

### `general_setup`

Tags:
- `packages`: install apt, pip, cargo, go packages.
- `scripts`: run scripts for visuals like gtk, fonts and other programs like dunst, i3.

Vars:
- `gaming`: install gaming related stuff.

```
ansible-playbook plays/general_setup.yml  --ask-become-pass
```

I run shell comands in Ansible knowing is not recommended but I wanted to have an exact copy (or the most similar possible) of the instructions provided by the creators of each program.
