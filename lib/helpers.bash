#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

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

function confirm {
    local prompt="${1:-Are you sure?}"
    if [[ ! -t 0 ]]; then
        die "confirmation required but no interactive terminal: ${prompt}"
    fi
    local reply
    read -r -p "${prompt} [y/N] " reply
    [[ "${reply}" =~ ^[Yy]$ ]]
}

function require_commands {
    local -a missing=()
    local cmd
    for cmd in "$@"; do
        if ! command -v "${cmd}" >/dev/null; then
            missing+=("${cmd}")
        fi
    done

    ((${#missing[@]} == 0)) || die "missing commands: ${missing[*]}"
}

ORIGINAL_PWD="${ORIGINAL_PWD:-${PWD}}"

function on_error {
    local -i exit_code="${?}"
    local script_name
    script_name="${BASH_SOURCE[1]:-${0}}"
    script_name="${script_name##*/}"

    if [[ -n "${ORIGINAL_PWD:-}" && -d "${ORIGINAL_PWD}" ]]; then
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
    if [[ -n "${ORIGINAL_PWD:-}" && -d "${ORIGINAL_PWD}" ]]; then
        cd "${ORIGINAL_PWD}"
    fi

    if declare -F cleanup >/dev/null; then
        cleanup
    fi
}

function kill_and_wait {
    local process_name="${1}"
    killall "${process_name}" || true
    while pgrep --uid "${UID}" --exact "${process_name}" >/dev/null; do
        sleep 0.3
    done
}

function quit_and_wait {
    local quit_cmd="${1}"
    local process_name="${2}"
    ${quit_cmd} || true
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

    # geometry: x y offset_x offset_y
    local -a geometry
    # shellcheck disable=SC2020  # tr 'x+' maps two chars to newlines, not a word pattern
    mapfile -t geometry < <(xrandr | grep 'connected primary' | awk '{print $4}' | tr x+ '\n\n')

    echo "$((geometry[0] - x_size - APPLET_X_GAP + geometry[2]))" "$((geometry[1] - y_size - APPLET_Y_GAP + geometry[3]))"
}

# Set by git_clone_pull_repo: "true" when the repo was cloned or received new commits
# shellcheck disable=SC2034  # consumed by sourcing installer scripts
declare GIT_REPO_CHANGED=true

function git_clone_pull_repo {
    local repo_url="$1"
    local repo_dir="$2"
    local force="${3:-false}"
    local repo_name="${repo_dir##*/}"

    GIT_REPO_CHANGED=true

    if [[ ! -d "${repo_dir}" ]]; then
        log "Cloning ${repo_name}"
        if [[ "${force}" == "true" ]]; then
            git clone --depth 1 --quiet "${repo_url}" "${repo_dir}"
        else
            git clone --quiet "${repo_url}" "${repo_dir}"
        fi
    else
        log "Updating ${repo_name}"
        local old_head
        old_head="$(git -C "${repo_dir}" rev-parse HEAD)"
        if [[ "${force}" == "true" ]]; then
            git -C "${repo_dir}" fetch --depth 1 --quiet
            git -C "${repo_dir}" reset --hard --quiet origin/HEAD
        else
            git -C "${repo_dir}" pull --ff-only --quiet
        fi
        if [[ "$(git -C "${repo_dir}" rev-parse HEAD)" == "${old_head}" ]]; then
            # shellcheck disable=SC2034  # consumed by sourcing installer scripts
            GIT_REPO_CHANGED=false
        fi
    fi
}

# Usage: github_latest_release_tag "owner/repo" -> echoes tag (e.g. "v0.47.4"), empty on failure
function github_latest_release_tag {
    local repo="$1"
    local url
    if ! url="$(curl --fail --no-progress-meter --head --location \
        --output /dev/null --write-out '%{url_effective}' \
        "https://github.com/${repo}/releases/latest")"; then
        return 0
    fi
    echo "${url##*/}"
}

# Usage: parse_force_flag "${1:-}" -> echoes "true"/"false"
function parse_force_flag {
    if [[ "${1:-}" == "--force" ]]; then
        echo true
    else
        echo false
    fi
}

function make_build_install {
    local build_dir="$1"
    cd "${build_dir}" || return 1

    local make_arg="${2:-}"

    log "Building ${build_dir##*/} from source"
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

trap on_error ERR SIGINT SIGTERM
trap on_exit EXIT
