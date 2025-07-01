#!/usr/bin/env bash

function install_docker() {
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install --yes ca-certificates curl
    sudo mkdir -p /etc/apt/keyrings
    sudo chmod 0755 /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(source /etc/os-release && echo "${VERSION_CODENAME}") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install --yes docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

# install_docker
