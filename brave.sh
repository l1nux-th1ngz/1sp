#!/bin/bash

# Set to exit immediately if a command exits with a non-zero status.
set -e

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if curl is installed, and install if not
if ! command_exists curl; then
  echo "curl not found. Installing curl..."
  sudo apt-get update
  sudo apt-get install -y curl
fi

# Define the Brave browser GPG key URL and destination
BRAVE_KEY_URL="https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg"
BRAVE_KEYRING_PATH="/usr/share/keyrings/brave-browser-archive-keyring.gpg"

# Define the Brave browser repository definition
BRAVE_REPO_DEFINITION="deb [arch=amd64 signed-by=${BRAVE_KEYRING_PATH}] https://brave-browser-apt-release.s3.brave.com/ stable main"
BRAVE_REPO_FILE="/etc/apt/sources.list.d/brave-browser-release.list"

echo "--- Brave Browser Installation Script ---"

# Check if the GPG key already exists
if [ -f "$BRAVE_KEYRING_PATH" ]; then
  echo "Brave browser GPG key already exists at $BRAVE_KEYRING_PATH."
else
  echo "Downloading the Brave browser GPG key..."
  # Download the Brave browser GPG key
  sudo curl -fsSL "${BRAVE_KEY_URL}" -o "${BRAVE_KEYRING_PATH}"
  echo "Brave browser GPG key downloaded successfully."
fi

# Check if the repository file already exists and contains the correct entry
if [ -f "$BRAVE_REPO_FILE" ] && grep -q "${BRAVE_REPO_DEFINITION}" "$BRAVE_REPO_FILE"; then
  echo "Brave browser repository entry already exists in $BRAVE_REPO_FILE."
else
  echo "Adding the Brave browser repository to sources.list.d..."
  # Add the Brave browser repository to sources.list.d
  echo "${BRAVE_REPO_DEFINITION}" | sudo tee "${BRAVE_REPO_FILE}" > /dev/null
  echo "Brave browser repository added successfully."
fi

echo "Updating package lists..."
# Update package lists
sudo apt-get update

# Check if Brave browser is already installed
if dpkg -s brave-browser &> /dev/null; then
  echo "Brave browser is already installed."
else
  echo "Installing Brave browser..."
  # Install Brave browser
  sudo apt-get -y install brave-browser
  echo "Brave browser installed successfully."
fi

echo "--- Installation Complete ---"
