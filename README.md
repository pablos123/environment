# Environment
I consider this environment to be simple, stable and with a versatile configuration.

I am using this set of tools since a lot of time and I do not think I will change them any time soon.

I resigned from the battle for visual consistency on Linux a long time ago, it is not worth it.

Probably I am using this on the latest version of _Debian_ (headless) or _Linux Mint_.

# New machine
```bash
# root
apt-get install --yes git sudo ntfs-3g
usermod -aG sudo <user>

# <user>
git clone 'https://github.com/pablos123/environment' "${HOME}/environment"
bash "${HOME}/environment/lib/upgrade.sh"
```

# Tried
Things I tried (used a considerable amount of time) but I do not use anymore. Just to remember.

|Tool|Reason|Alternative|
|-|-|-|
|wezterm|Incredible, but being gpu accelerated makes it incredible slow in potatoes|terminator|
|alacrity|I like wezterm|terminator|
|ghostty|I like wezterm|terminator|
|xterm|Incredible but I like to easy customize things if I want|terminator|
|gnome-terminal|Does not store configs in ~/.config|terminator|
|dwm|My first WM. I love it. I been using i3 it for a lot of years now|i3|
|sway|I like xorg|i3|
|gnome|I do not like DE's also I am using a computer not a smartphone|i3|
|cinnamon|I do not like DE's. Best DE out there|i3|
|kde|I do not like DE's|i3|
|nemo|Great but creates directories in my home|xfe|
|nautilus|It is not my thing|xfe|
|obsidian|Incredible, but I like being in the terminal|nvim|
|vscode|Incredible, but I like being in the terminal|nvim|
|firefox|Same as chrome but worse|chrome|
|zellij|I really do not need a terminal multiplexer|none|
|tmux|I really do not need a terminal multiplexer|none|


Distributions I tried. Just to remember.
|Distribution|
|-|
|Debian|
|Mint|
|Ubuntu|
|Lubuntu|
|Xubuntu|
|Kubuntu|
|Arch|
|Artix|
|Fedora|
|Bodhi|
|TinyCore|
|Puppy|
