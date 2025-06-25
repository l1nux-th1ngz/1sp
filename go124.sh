#!/bin/bash

# Download Go
wget https://go.dev/dl/go1.24.4.linux-amd64.tar.gz

# Remove existing Go installation
sudo rm -rf /usr/local/go

# Extract the new version
sudo tar -C /usr/local -xzf go1.24.4.linux-amd64.tar.gz

# Add to .bashrc
if ! grep -qxF 'export PATH=$PATH:/usr/local/go/bin' ~/.bashrc; then
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    echo "PATH updated in .bashrc"
    echo "source ~/.bashrc" >> ~/.bashrc  # Ensure this line is added to .bashrc
fi

# Add to .zshrc
if ! grep -qxF 'export PATH=$PATH:/usr/local/go/bin' ~/.zshrc; then
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
    echo "PATH updated in .zshrc"
    echo "source ~/.zshrc" >> ~/.zshrc  # Ensure this line is added to .zshrc
fi

# Apply changes to the current session
export PATH=$PATH:/usr/local/go/bin

# Verify installation
go version

