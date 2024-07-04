# Environment

I love a fast, simple, clean, robust, versatile, **_that works_** and automatized environment.

I am using this set of tools since a lot of time and I don't think I will change them soon, they just work.

I code a lot, a lot of that is scripting. Some of those scripts survive the void and are here.

Others survive but I will not use them any time soon. Those are here https://gist.github.com/pablos123

Probably I am using this on the latest version of **_Linux Mint_**.

\(Although, except for apt operations, this is probably distro agnostic.\)

## Managers

- Upgrade system: `sys_manager -u`
- Compile neovim: `sys_manager -n`
- Reload current theme: `theme_manager`
- Set theme: `theme_manager -t <theme>`
- List available themes: `theme_manager -l`
- Install gtk themes: `gtk_manager -i`
- List gtk themes: `gtk_manager -l`
- Install fonts: `font_manager -i`
- List installed fonts: `font_manager -l`
- System information: `info_manager`

All managers have the `-e` (explain) and `-h` (help) flags.

## Executables

### dmenu runners

- Search in google: `dmenu_search` (Super + Shift + s)
- Connect to host: `dmenu_hosts` (Super + Ctrl + c)
- Change theme: `dmenu_themes`

### Social media

- Check letterboxd unfollowers: `letterboxd_unfollowers`
- Check instagram unfollowers: `instagram_unfollowers`

### Utils

- Calendar applet: `calendar_applet` (Super + Shift + D)
- Notify low batteries: `battery_notify`
- View batteries status: `battery_status`
- Clean X urgent windows : `clean_urgent`
- Lock screen: `lock_screen`
- Scan QR: `qr_scanner`
- Toggle notifications: `quiet_mode`
- Set a video as wallpaper: `videowall`
- Set a random wallpaper: `set_wallpaper`

## Bash functions

- View all escaped colors: `colors`
- Find name in current dir: `nfind`
- Edit crontab but create backup first: `ecrontab`
- List available completions: `list_completions`
- Load completions: `load_completions`
- Reset a repository: `reset_repo`
- Normalize wallpapers: `normalize_wallpapers`
