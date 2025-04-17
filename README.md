# Environment
I consider this environment to be simple, stable and with a versatile configuration.

I'm using this set of tools since a lot of time and I don't think I will change them any time soon.

I resigned from the battle for visual consistency on Linux a long time ago, it is not worth it.

Probably I am using this on the latest version of _Debian_ (headless) or (maybe) _Linux Mint_.

# New machine
```bash
# With root
apt-get install --yes git sudo ntfs-3g
usermod -aG sudo pab
exit

# With pab
git clone 'https://github.com/pablos123/environment' "${HOME}/environment"
bash "${HOME}/environment/lib/upgrade.sh"
```

# Tried
Things I tried but I do not use anymore because of _reason_. Just to remember.

|tool|reason|alternative|
|-|-|-|
|wezterm|Incredible, but being gpu accelerated makes it incredible slow in potatoes|terminator|
|xterm|Incredible but I like to customize (a little bit) things|terminator|
|alacrity|wezterm is better|terminator|
|ghostty|wezterm is better|terminator|
|gnome-terminal|Needs a wrapper to run? A lot of problems. Not prepared to run outside a DE|terminator|
|dwm|My first WM. I love it, but i3 is a lot more handy and I been using it for a lot of years now|i3|
|sway|I like xorg|i3|
|gnome|I don't like DE's|i3|
|cinnamon|Best DE out there|i3|
|nemo|Creates stupid directories in my home|xfe|
|nautilus|Creates stupid directories in my home|xfe|
|firefox|Same as Chrome|google-chrome|
|obsidian|Incredible, but I like being in the terminal|nvim|
|zellij|A lot of overhead just for doing what tmux does better. I really do not need a terminal multiplexer outside a server|none|
|tmux|I really do not need a terminal multiplexer outside a server|none|
|screen|I really do not need a terminal multiplexer outside a server|none|
