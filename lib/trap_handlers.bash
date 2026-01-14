#!/usr/bin/env bash
# Trap handlers for error handling and cleanup

# Source print functions for die()
source "${HOME}/environment/lib/print_functions.bash"

# Capture original working directory for cleanup
ORIGINAL_PWD="$(pwd)"

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

# Register trap handlers
trap on_error ERR SIGINT SIGTERM
trap on_exit EXIT
