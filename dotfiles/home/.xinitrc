export $(dbus-launch)

xrdb -merge ~/.Xresources &
# xmodmap ~/.Xmodmap &  # uncomment if you create an Xmodmap file for key remappings

# Keyboard settings
xset r rate 230 50

# Disable screen blanking and DPMS power-off. Without these, X uses its built-in
# defaults (blank saver at ~10 min, DPMS on), which black out the screen and can
# leave an external monitor hard to wake. Explicit 'off' is required; removing the
# lines is not the same as disabling.
xset s off
xset -dpms

# Export X11 environment to systemd user session
systemctl --user import-environment DISPLAY XAUTHORITY DBUS_SESSION_BUS_ADDRESS
systemctl --user start x-session.target

exec i3
