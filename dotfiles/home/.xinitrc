# Necessary
# The XDG_ variable set is managed by pam service.
# But in Mint this is not happening.
[ -z "$XDG_RUNTIME_DIR" ] && export XDG_RUNTIME_DIR="/run/user/$(id -u)"
xrdb -load ~/.Xresources &

# Other daemons
picom &
nm-applet &
blueman-applet &
solaar -w hide &
dunst &

# My daemons
keyboard_config -d &
monitors_config -d &

# Depends on monitors_config
sleep 1
wallpaper_config -d &

exec dbus-launch --exit-with-session i3
