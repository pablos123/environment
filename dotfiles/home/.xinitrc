# Systemd user bus, not dbus-launch: gnome-keyring's secrets service lives here.
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/bus"

export XDG_CURRENT_DESKTOP=i3
export XDG_SESSION_DESKTOP=i3
export XDG_SESSION_TYPE=x11

xrdb -merge ~/.Xresources &
# xmodmap ~/.Xmodmap &  # uncomment if you create an Xmodmap file for key remappings

# Keyboard settings
xset r rate 230 50

# Disable screen blanking and DPMS power-off.
xset s off
xset -dpms

# Export X11 environment to systemd user session
systemctl --user import-environment DISPLAY XAUTHORITY \
    XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE
dbus-update-activation-environment --systemd DISPLAY XAUTHORITY \
    XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE
systemctl --user start x-session.target

exec i3
