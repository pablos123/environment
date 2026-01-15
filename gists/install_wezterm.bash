#!/usr/bin/env bash
set -Eeuo pipefail

# --------------------------------------------------
# Setup WezTerm repository
# --------------------------------------------------
echo "==> Setting up WezTerm repository"
sudo mkdir -p /etc/apt/keyrings
sudo chmod 0755 /etc/apt/keyrings
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

# --------------------------------------------------
# Install WezTerm
# --------------------------------------------------
echo "==> Installing WezTerm"
sudo apt-get update
sudo apt-get install --yes wezterm
