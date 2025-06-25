#!/bin/bash

# Define variables
JQ_URL="https://github.com/jqlang/jq/releases/download/jq-1.8.0/jq-linux-amd64"
JQ_PATH="/usr/local/bin/jq"

# Download jq
wget -O jq "$JQ_URL"

# Move to /usr/local/bin
sudo mv jq "$JQ_PATH"

# Make executable
sudo chmod +x "$JQ_PATH"

# Verify installation
if command -v jq > /dev/null; then
    echo "jq successfully installed at $(command -v jq)"
else
    echo "Failed to install jq" >&2
    exit 1
fi
