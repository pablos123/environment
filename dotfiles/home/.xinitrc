export $(dbus-launch)

xrdb -load ~/.Xresources &

# Other daemons
picom --daemon &
nm-applet &
blueman-applet &
solaar -w hide &
dunst &

# Keyboard settings
xset r rate 230 50
xset s 900
xset dpms 0 0 3600

# My daemons
monitors_config -d &
battery_notify -d &

# Depends on monitors_config
sleep 1
wallpaper_config -d &

exec i3

