# Necessary
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
export XDG_SESSION_TYPE=x11
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

# Depends of monitors_config
sleep 1
wallpaper_config -d &

exec i3
