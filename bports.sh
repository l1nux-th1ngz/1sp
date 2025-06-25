#!/bin/bash

set -e  # Exit immediately if a command fails

echo "This script will add the best Bookworm repositories"

# Remove current sources.list if exists
if sudo rm -f /etc/apt/sources.list; then
    echo "Old sources.list removed."
else
    echo "Failed to remove existing sources.list or it does not exist."
fi

sudo apt-get update

# Create a new sources.list with Debian Bookworm repositories
cat <<EOL | sudo tee /etc/apt/sources.list > /dev/null
deb https://ftp.debian.org/debian/ bookworm contrib main non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm-updates contrib main non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm-proposed-updates contrib main non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm-backports contrib main non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main non-free-firmware
EOL
echo "New sources.list created."

# Update package lists
if sudo apt-get update; then
    echo "Package list updated successfully."
else
    echo "Failed to update package list." >&2
    exit 1
fi

echo "Initial repositories added and package list updated."
echo "-------------------------------------------------------------------------------"

# Install fasttrack packages
if sudo apt-get -y install firmware-linux-nonfree fasttrack-archive-keyring devscripts; then
    echo "Required packages installed."
else
    echo "Failed to install required packages." >&2
    exit 1
fi

# Append fasttrack repositories
sudo bash -c 'cat <<EOL >> /etc/apt/sources.list
deb https://fasttrack.debian.net/debian-fasttrack/ bookworm-fasttrack main contrib
deb https://fasttrack.debian.net/debian-fasttrack/ bookworm-backports-staging main contrib
EOL'

# Update again
if sudo apt-get update; then
    echo "Updated after adding fasttrack repositories."
else
    echo "Failed to update after adding fasttrack repositories." >&2
    exit 1
fi

# Perform full dist-upgrade
if sudo apt-get -y dist-upgrade; then
    echo "System upgraded successfully."
else
    echo "System upgrade failed." >&2
    exit 1
fi

# Prompt user for backports kernel installation
read -p "Would you like to install the backports kernel? (Y/n): " response
if [[ "$response" =~ ^[Yy]$ || -z "$response" ]]; then
    echo "Installing backports kernel and related packages..."
    sudo apt-get install -y lsb-release curl apt-transport-https bison git-lfs git-all util-linux
    sudo apt-get -t bookworm-backports install -y linux-image-amd64 linux-headers-amd64 firmware-linux meson

    # Re-update package list
    echo "Running apt update again..."
    sudo apt-get update
else
    echo "Backports kernel installation skipped."
fi

echo "Script completed. Reboot your system to start using the new kernel."
