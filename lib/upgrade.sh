#!/usr/bin/env bash

set -x

original_path="$(pwd)"

function cwd_on_exit() {
    cd "${original_path}"
}

trap cwd_on_exit EXIT ERR SIGINT SIGTERM

source "${HOME}/environment/lib/env_variables.sh"

mkdir -p "${REPOS_PATH}" "${HOME}/screenshots" "${HOME}/projects" "${HOME}/bin"

for installer in "${HOME}/environment/lib/installers/"*; do
    source "${installer}"
done

sudo apt-get autoremove --purge --yes

/usr/bin/env bash "${HOME}/environment/bin/reload_environment"

echo "Done! Remember to reboot your pc!"
