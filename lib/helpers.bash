#!/usr/bin/env bash
set -Eeuo pipefail

# --------------------------------------------------
# Print functions
# --------------------------------------------------

function log() {
    printf '\033[1;32m==>\033[0m %s\n' "${1:-}" >&2
}

function warn() {
    printf '\033[1;33m[WARN]\033[0m %s\n' "${1:-}" >&2
}

function die() {
    printf '\033[1;31m[ERROR]\033[0m %s\n' "${1:-}" >&2
    exit 1
}

# --------------------------------------------------
# Trap handlers
# --------------------------------------------------

ORIGINAL_PWD="${ORIGINAL_PWD:-$(pwd)}"

function on_error() {
    local exit_code="${?}"
    local script_name
    script_name="$(basename "${BASH_SOURCE[1]:-${0}}")"

    if [[ -n "${ORIGINAL_PWD:-}" ]] && [[ -d "${ORIGINAL_PWD}" ]]; then
        cd "${ORIGINAL_PWD}" || true
    fi

    die "Script '${script_name}' failed (exit code ${exit_code})"
}

function on_exit() {
    if [[ -n "${ORIGINAL_PWD:-}" ]] && [[ -d "${ORIGINAL_PWD}" ]]; then
        cd "${ORIGINAL_PWD}" || true
    fi

    if declare -F cleanup >/dev/null; then
        cleanup
    fi
}

# --------------------------------------------------
# Process management
# --------------------------------------------------

function kill_and_wait() {
    local process_name="${1}"
    killall "${process_name}" || true
    while pgrep --uid "${UID}" --exact "${process_name}" >/dev/null; do
        sleep 0.3
    done
}

function quit_and_wait() {
    local quit_cmd="${1}"
    local process_name="${2}"
    ${quit_cmd} || true
    while pgrep --uid "${UID}" --exact "${process_name}" >/dev/null; do
        sleep 0.3
    done
}

# --------------------------------------------------
# Applet position
# --------------------------------------------------

readonly APPLET_X_GAP=16
readonly APPLET_Y_GAP=42

function calculate_applet_position() {
    local x_size y_size res

    x_size="${1:-}"
    y_size="${2:-}"

    if [[ -z "${x_size}" ]] || [[ ! "${x_size}" =~ ^[0-9]+$ ]] ||
       [[ -z "${y_size}" ]] || [[ ! "${y_size}" =~ ^[0-9]+$ ]]; then
        return 1
    fi

    # array: x y offset_x offset_y
    mapfile -t res < <(xrandr | grep 'connected primary' | awk '{print $4}' | tr x+ '\n\n')

    echo -n "$(( res[0] - x_size - APPLET_X_GAP + res[2] ))" "$(( res[1] - y_size - APPLET_Y_GAP + res[3] ))"
}

# --------------------------------------------------
# Git management
# --------------------------------------------------

# Clone or update a git repository
# Usage: git_clone_pull_repo <url> <directory> [force]
# - force: "true" for shallow clone + hard reset (external repos)
#          "false" for full clone + ff-only pull (default, personal repos)
function git_clone_pull_repo() {
    local repo_url="$1"
    local repo_dir="$2"
    local force="${3:-false}"

    if [[ ! -d "${repo_dir}" ]]; then
        log "Cloning $(basename "${repo_dir}")"
        if [[ "${force}" == "true" ]]; then
            git clone --depth 1 --quiet "${repo_url}" "${repo_dir}"
        else
            git clone --quiet "${repo_url}" "${repo_dir}"
        fi
    else
        log "Updating $(basename "${repo_dir}")"
        if [[ "${force}" == "true" ]]; then
            git -C "${repo_dir}" fetch --depth 1 --quiet
            git -C "${repo_dir}" reset --hard --quiet origin/HEAD
        else
            git -C "${repo_dir}" pull --ff-only --quiet
        fi
    fi
}

# Build and install from source using make
# Usage: make_build_install <directory> [make_args]
function make_build_install() {
    local build_dir="$1"
    local make_arg="${2:-}"

    cd "${build_dir}" || return 1

    log "Building $(basename "${build_dir}") from source"
    {
        sudo make clean 2>/dev/null || true
        if [[ -n "${make_arg}" ]]; then
            make "${make_arg}"
        else
            make
        fi
        sudo make install
    } >/dev/null
}

# --------------------------------------------------
# Register trap handlers
# --------------------------------------------------

trap on_error ERR SIGINT SIGTERM
trap on_exit EXIT
