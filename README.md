# Environment
I consider this environment to be simple, stable and with a versatile configuration.

I am using this set of tools since a lot of time and I do not think I will change them any time soon.

I resigned from the battle for visual consistency a long time ago, it is not worth it.

I use the latest stable release of headless Debian.

# New machine
```bash
# root
apt-get install --yes git sudo ntfs-3g
usermod -aG sudo pab

# pab
git clone 'https://github.com/pablos123/environment' "${HOME}/environment"
bash "${HOME}/environment/lib/upgrade.sh"
```
