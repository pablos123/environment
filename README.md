# NVIM setup

## Playbooks:
- build.yml (clone the nvim repo and build it from source)
- config.yml (clone my nvim config repo and make nvim runnable, this will not install de Language Servers)
- language\_servers.yml (installs all the language servers binaries for linters and etc. to work properly)
- setup.yml (run build.yml, config.yml and install the language servers too)

## Roles:
language\_servers: contains the tasks for each of the language servers configured in the nvim config.

## Run:
You can run each playbook separately:

- `ansible-playbook build.yml --ask-become-pass` to build from source and have the last version (estable) of neovim.
- `ansible-playbook config.yml --ask-become-pass` to have the config without the LS. This is good to reset the config to the last functional commit if you need to.
- `ansible-playbook language_servers.yml --ask-become-pass` to install all the language servers binaries.
- `ansible-playbook setup.yml --ask-become-pass` to run all the other playbooks.


## Troubleshooting:
You can run:

- `ansible-playbook build.yml --ask-become-pass -t reset`
- `ansible-playbook config.yml --ask-become-pass -t reset`

to delete the directories before doing the tasks if you encounter some problems.

(For example, the 'make' command when building neovim is broken because the cache folder)
