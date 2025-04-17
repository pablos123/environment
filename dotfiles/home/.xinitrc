picom &
nm-applet &
blueman-applet &
solaar -w hide &
dunst &

xrdb -load ~/.Xresources &

monitors_config -d &
keyboard_config -d &

sleep 1 && wallpaper_config -d &

exec dbus-launch --exit-with-session i3
