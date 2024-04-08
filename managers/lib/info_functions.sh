function user_info() {
    echo "User: $(id | awk '{print $1" "$2}')"
}

function hostname_info() {
    echo "Hostname: $(hostname)"
}

function uname_info() {
    echo "Kernel release: $(uname --kernel-release)"
}

function cpu_info() {
    lscpu | awk -F ':' '/^Architecture|^CPU\(s\)|^Model name/ {print $1":"$2}'
}

function lsb_info() {
    lsb_release -a 2>/dev/null | awk -F ':' '/^Distributor ID|^Description|^Release|^Codename/ {print $1":"$2}'
}

function mem_info() {
    free -h | awk '/^Mem/ {print $1" "$2}'
}

function wmctrl_info() {
    wmctrl_exists="$(which wmctrl)"
    if [[ -n $wmctrl_exists ]]; then
        wmctrl -m | awk '/^Name/ {print "WM "$1" "$2}'
    fi
}

info_functions=(
    user_info
    hostname_info
    uname_info
    cpu_info
    lsb_info
    mem_info
    wmctrl_info
)
