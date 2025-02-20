#!/usr/bin/env bash

set -e -x

original_path="$(pwd)"

function cwd_on_exit() {
    cd "${original_path}"
}

trap cwd_on_exit EXIT ERR SIGINT SIGTERM SIGKILL

mkdir -p "${REPOS_PATH}" "${HOME}/screenshots" "${HOME}/projects" "${HOME}/bin"

for installer in "${HOME}/environment/lib/installers/install_"*; do
    bash "${installer}"
done

sudo apt autopurge -y

bash "${HOME}/environment/bin/reload_environment"

echo "Done! Remember to reboot your pc!"
