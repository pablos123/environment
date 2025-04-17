picom &
nm-applet &
blueman-applet &
solaar -w hide &
dunst &

monitors_config -d &
keyboard_config -d &
wallpaper_config -d &

xrdb -load ~/.Xresources &

exec dbus-launch --exit-with-session i3
