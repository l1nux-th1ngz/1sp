#!/bin/bash

set -e

# Create directory for charm GPG key
sudo mkdir -p /etc/apt/keyrings

# Download and add the charm repository GPG key
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg

# Add the charm repository to sources list
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list

# Update package list
sudo apt-get update
