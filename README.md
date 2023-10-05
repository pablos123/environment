# Linux Mint setup

Why Ansible?

Ansible is a programming language build for provisions, beyond that I wanted to have a nice 'self-documented' code to build my environment.
In general is Linux Mint but at least I try to keep it Ubuntu/Debian based at this point.

I run shell comands in Ansible knowing is not recommended but I wanted to have an exact copy (or the most similar possible) of the instructions provided by the creators of each program.

## Playbooks
Run the playbooks with the `--ask-become-pass` option.

### `general_setup`

```
ansible-playbook plays/general_setup.yml [-t packages -t scripts -t repos -t gaming ] --ask-become-pass
```

Whenever you want to upgrade your system you can execute `fullupgrade`

### `nvim_setup`
```
ansible-playbook plays/nvim_setup.yml [-t build -t config] --ask-become-pass
```
