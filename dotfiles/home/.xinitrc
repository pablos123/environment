export $(dbus-launch)

xrdb -load ~/.Xresources &

# Other daemons
# I will try to not use tray icons for a while.
# picom --daemon &
# nm-applet &
# blueman-applet &
# solaar -w hide &
dunst &

# My daemons
keyboard_config -d &
monitors_config -d &
battery_notify -d &

# Depends on monitors_config
sleep 1
wallpaper_config -d &

exec i3

