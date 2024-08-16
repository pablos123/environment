# Environment

I love a fast, simple, clean, robust, versatile and automatized environment.

Probably I am using this on the latest version of _Linux Mint_.

I'm using this set of tools since a lot of time and I don't think I will change them any time soon.

I resigned from the battle for visual consistency on Linux a long time ago, it is not worth it, at all.

I'm using default themes or just some sober theme that fits well with that particular application.

I came to the conclussion that defaults in general are better than anything else.

I code a lot, some of that code survives and I use it in my environment, while the rest goes to my [gits](https://gist.github.com/pablos123).

## Managers

- System manager: `sys_manager -h`
- Theme manager: `theme_manager -h`
- Fonts manager: `font_manager -h`

## Executables

### Social media

- Check Letterboxd unfollowers: `letterboxd_unfollowers`
- Check Instagram unfollowers: `instagram_unfollowers`

### Utils

- Calendar applet: `calendar_applet`
- Notify low batteries: `battery_notify`
- View batteries status: `battery_status`
- Clean X urgent windows : `clean_urgent`
- Lock screen: `lock_screen`
- Scan QR: `qr_scanner`
- Toggle notifications: `quiet_mode`
- Set a video as wallpaper: `videowall`
- Set a random wallpaper: `set_wallpaper`
- View kernel versions releases: `kernel_versions`

## Bash functions

- View all escaped colors: `colors`
- Find name in current dir: `nfind`
- Edit crontab but create a backup first: `ecrontab`
- List available completions: `list_completions`
- Load completions: `load_completions`
- Reset a repository: `reset_repo`
- Normalize wallpapers: `normalize_wallpapers`

# New machine

```bash
git clone <this> "$HOME/environment"
"$HOME/environment/managers/init_manager"
```
