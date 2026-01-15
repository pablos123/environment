#!/usr/bin/env bash
set -Eeuo pipefail

readonly RUSTUP_INSTALLER="/tmp/rustup_installer.sh"

# --------------------------------------------------
# Remove existing Rust installation
# --------------------------------------------------
echo "==> Removing existing Rust installation"
sudo apt-get purge --yes rustc cargo 2>&1 || true
sudo apt-get autoremove --purge --yes 2>&1 || true

# --------------------------------------------------
# Download and install rustup
# --------------------------------------------------
echo "==> Installing rustup"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "${RUSTUP_INSTALLER}"
/usr/bin/env sh "${RUSTUP_INSTALLER}" -y

# --------------------------------------------------
# Source cargo environment and update
# --------------------------------------------------
# shellcheck source=/dev/null
source "${HOME}/.cargo/env" || true
rustup update || true

# --------------------------------------------------
# Cleanup
# --------------------------------------------------
rm -f "${RUSTUP_INSTALLER}" || true
