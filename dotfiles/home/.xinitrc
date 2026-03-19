export $(dbus-launch)

xrdb -merge ~/.Xresources &
# xmodmap ~/.Xmodmap &  # uncomment if you create an Xmodmap file for key remappings

# Keyboard settings
xset r rate 230 50
xset s 900
xset dpms 0 0 3600

# Export X11 environment to systemd user session
systemctl --user import-environment DISPLAY XAUTHORITY DBUS_SESSION_BUS_ADDRESS
systemctl --user start x-session.target

exec i3
