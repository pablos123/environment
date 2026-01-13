#!/usr/bin/env bash
# --------------------------------------------------
# NOTE:
# This file is intended to be SOURCED, not executed.
# Must be compatible with set -Eeuo pipefail.
# --------------------------------------------------

RUSTUP_INSTALLER="/tmp/rustup_installer.sh"

# --------------------------------------------------
# Remove existing Rust installation
# --------------------------------------------------
sudo apt-get purge --yes rustc cargo >/dev/null 2>&1 || true
sudo apt-get autoremove --purge --yes >/dev/null 2>&1 || true

# --------------------------------------------------
# Download and install rustup
# --------------------------------------------------
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "${RUSTUP_INSTALLER}"
/usr/bin/env sh "${RUSTUP_INSTALLER}" -y >/dev/null 2>&1

# --------------------------------------------------
# Source cargo environment and update
# --------------------------------------------------
# shellcheck source=/dev/null
source "${HOME}/.cargo/env" || true
rustup update >/dev/null 2>&1 || true

# --------------------------------------------------
# Cleanup
# --------------------------------------------------
rm -f "${RUSTUP_INSTALLER}" || true

unset RUSTUP_INSTALLER
