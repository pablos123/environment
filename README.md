# Linux Mint setup

### General Setup

```
ansible-playbook plays/general_setup.yml [-t packages -t scripts -t repos -t gaming ] --ask-become-pass
```

### Build nvim
```
ansible-playbook plays/nvim_setup.yml [-t build -t config] --ask-become-pass
```
