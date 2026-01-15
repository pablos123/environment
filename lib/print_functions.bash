#!/usr/bin/env bash
set -Eeuo pipefail

# Print utility functions

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
