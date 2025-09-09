# Environment

I consider this environment to be simple, stable and with a versatile configuration.

I am using this set of tools since a lot of time and I do not think I will change them any time soon.

I resigned from the battle for visual consistency a long time ago, it is not worth it.

I use the latest stable release of headless Debian.

# New machine

```bash
# root
apt-get install --yes git sudo ntfs-3g rfkill && usermod -aG sudo pab

# pab
git clone 'https://github.com/pablos123/environment' "${HOME}/environment" && "${HOME}/environment/bin/setup_machine"
```

# TODO

TODO with Debian 13

- [ ] Use XLibre instead of XOrg
- [ ] eza is now in the official repos, no more installer.
- [ ] Make a script for root to do the common things (delete the 'cd' line in apt sources, clean the network configurations, etc.). Also install packages and add pab to sudo group.
- [ ] Maybe bootstrap this repository? (clone with https, copy ssh keys from X usb (as argument), change the origin, run setup_machine)
