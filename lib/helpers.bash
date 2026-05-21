#!/usr/bin/env bash

# Shared shell library for scripts in this repo.

set -Eeuo pipefail

function log {
    printf '\033[1;32m==>\033[0m %s\n' "${1:-}" >&2
}

function warn {
    printf '\033[1;33m[WARN]\033[0m %s\n' "${1:-}" >&2
}

function die {
    printf '\033[1;31m[ERROR]\033[0m %s\n' "${1:-}" >&2
    exit 1
}

function require_commands {
    local -a missing=()
    local cmd
    for cmd in "$@"; do
        if ! command -v "${cmd}" >/dev/null; then
            missing+=("${cmd}")
        fi
    done

    if ((${#missing[@]} > 0)); then
        die "missing commands: ${missing[*]}"
    fi
}

ORIGINAL_PWD="${ORIGINAL_PWD:-${PWD}}"

function on_error {
    local -i exit_code="${?}"
    local script_name
    script_name="${BASH_SOURCE[1]:-${0}}"
    script_name="${script_name##*/}"

    if [[ -n "${ORIGINAL_PWD:-}" ]] && [[ -d "${ORIGINAL_PWD}" ]]; then
        cd "${ORIGINAL_PWD}"
    fi

    case "${exit_code}" in
        "130")
            die "SIGINT received"
            ;;
        "143")
            die "SIGTERM received"
            ;;
        *)
            die "Script '${script_name}' failed (exit code ${exit_code})"
            ;;
    esac
}

function on_exit {
    if [[ -n "${ORIGINAL_PWD:-}" ]] && [[ -d "${ORIGINAL_PWD}" ]]; then
        cd "${ORIGINAL_PWD}"
    fi

    if declare -F cleanup >/dev/null; then
        cleanup
    fi
}

function kill_and_wait {
    local process_name="${1}"
    if ! killall "${process_name}"; then
        :
    fi
    while pgrep --uid "${UID}" --exact "${process_name}" >/dev/null; do
        sleep 0.3
    done
}

function quit_and_wait {
    local quit_cmd="${1}"
    local process_name="${2}"
    if ! ${quit_cmd}; then
        :
    fi
    while pgrep --uid "${UID}" --exact "${process_name}" >/dev/null; do
        sleep 0.3
    done
}

declare -ri APPLET_X_GAP=16
declare -ri APPLET_Y_GAP=42

function calculate_applet_position {
    local x_size="${1:-}"
    local y_size="${2:-}"
    if [[ -z "${x_size}" || ! "${x_size}" =~ ^[0-9]+$ || -z "${y_size}" || ! "${y_size}" =~ ^[0-9]+$ ]]; then
        return 1
    fi

    # array: x y offset_x offset_y
    local -a res
    # shellcheck disable=SC2020  # tr 'x+' maps two chars to newlines, not a word pattern
    mapfile -t res < <(xrandr | grep 'connected primary' | awk '{print $4}' | tr x+ '\n\n')

    echo "$((res[0] - x_size - APPLET_X_GAP + res[2]))" "$((res[1] - y_size - APPLET_Y_GAP + res[3]))"
}

function git_clone_pull_repo {
    local repo_url="$1"
    local repo_dir="$2"
    local force="${3:-false}"
    local repo_name="${repo_dir##*/}"

    if [[ ! -d "${repo_dir}" ]]; then
        log "Cloning ${repo_name}"
        if [[ "${force}" == "true" ]]; then
            git clone --depth 1 --quiet "${repo_url}" "${repo_dir}"
        else
            git clone --quiet "${repo_url}" "${repo_dir}"
        fi
    else
        log "Updating ${repo_name}"
        if [[ "${force}" == "true" ]]; then
            git -C "${repo_dir}" fetch --depth 1 --quiet
            git -C "${repo_dir}" reset --hard --quiet origin/HEAD
        else
            git -C "${repo_dir}" pull --ff-only --quiet
        fi
    fi
}

function make_build_install {
    local build_dir="$1"
    if ! cd "${build_dir}"; then
        return 1
    fi

    local make_arg="${2:-}"

    log "Building ${build_dir##*/} from source"
    {
        if ! sudo make clean 2>/dev/null; then
            :
        fi
        if [[ -n "${make_arg}" ]]; then
            make "${make_arg}"
        else
            make
        fi
        sudo make install
    } >/dev/null
}

trap on_error ERR SIGINT SIGTERM
trap on_exit EXIT
