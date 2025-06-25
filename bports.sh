#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "This script will add the best Bookworm repositories"

# Remove current sources.list
sudo rm -f /etc/apt/sources.list

# Create a new sources.list with Debian Bookworm repositories
cat <<EOL | sudo tee /etc/apt/sources.list > /dev/null
deb https://ftp.debian.org/debian/ bookworm contrib main non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm-updates contrib main non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm-proposed-updates contrib main non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm-backports contrib main non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main non-free-firmware
EOL

# Update package lists
sudo apt-get update

echo "Initial repositories added and package list updated."
echo "-------------------------------------------------------------------------------"

# Install necessary packages
sudo apt-get -y install firmware-linux-nonfree fasttrack-archive-keyring devscripts

# Append fasttrack repositories to sources.list
sudo bash -c 'cat <<EOL >> /etc/apt/sources.list
deb https://fasttrack.debian.net/debian-fasttrack/ bookworm-fasttrack main contrib
deb https://fasttrack.debian.net/debian-fasttrack/ bookworm-backports-staging main contrib
EOL'

# Update package lists again
sudo apt-get update
sudo apt-get -y dist-upgrade

echo "Fasttrack repositories added and package list updated."
echo "-------------------------------------------------------------------------------"

# Adding Charm repo
# Create directory for charm GPG key
sudo mkdir -p /etc/apt/keyrings

# Download and add the charm repository GPG key
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg

# Add the charm repository to sources list with correct distribution and component
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ stable main" | sudo tee /etc/apt/sources.list.d/charm.list

# Update package list
sudo apt-get update
echo "-------------------------------------------------------------------------------"

# Prompt user whether to install backports kernel
read -p "Would you like to install the backports kernel? (Y/n): " response
if [[ "$response" =~ ^[Yy]$ || -z "$response" ]]; then
    # Install necessary tools
    sudo apt-get install -y lsb-release curl apt-transport-https bison

    # Install backports kernel and headers
    sudo apt-get -t bookworm-backports install -y linux-image-amd64 linux-headers-amd64 firmware-linux meson

    # Update again to ensure latest packages
    echo "Running apt update again..."
    sudo apt-get update
fi

echo "Script completed. Reboot system to use the new kernel."
