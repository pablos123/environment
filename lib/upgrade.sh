#!/usr/bin/env bash

set -x

original_path="$(pwd)"

function cwd_on_exit() {
    cd "${original_path}"
}

trap cwd_on_exit EXIT ERR SIGINT SIGTERM

. "${HOME}/environment/lib/env_variables.sh"

directories=(
    "${REPOS_PATH}"
    "${HOME}/bin"
    "${HOME}/desktop"
    "${HOME}/downloads"
    "${HOME}/templates"
    "${HOME}/public"
    "${HOME}/documents"
    "${HOME}/music"
    "${HOME}/images"
    "${HOME}/videos"
    "${HOME}/testing"
)

mkdir -p "${directories[@]}"

for installer in "${HOME}/environment/lib/installers/"*; do
    source "${installer}"
done

sudo apt-get autoremove --purge --yes

/usr/bin/env bash "${HOME}/environment/bin/reload_environment"

echo "Done! Remember to reboot your pc!"
