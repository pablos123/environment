#!/usr/bin/env bash

set -x

original_path="$(pwd)"

function cwd_on_exit_err() {
    cd "${original_path}" || exit 1
    exit 1
}

function cwd_on_exit() {
    cd "${original_path}" || exit 1
    exit 0
}

trap cwd_on_exit EXIT
trap cwd_on_exit_err ERR SIGINT SIGTERM

. "${HOME}/environment/lib/env_variables.sh"

directories=(
    "${REPOS_PATH}"
    "${HOME}/bin"
    "${HOME}/.local/bin/"
    "${HOME}/playground"
    "${HOME}/images/wallpapers"
    "${HOME}/images/screenshots"
)
mkdir -p "${directories[@]}"

for installer in "${HOME}/environment/lib/installers/"*; do
    command source "${installer}"
done

sudo apt-get autoremove --purge --yes

command -v flatpak &&
    flatpak update -y

/usr/bin/env bash "${HOME}/environment/bin/reload_environment"

echo "Done! Remember to reboot your pc!"
