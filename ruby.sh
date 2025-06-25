#!/bin/bash

# Clone rbenv repository
echo "Cloning rbenv repository..."
git clone https://github.com/rbenv/rbenv.git ~/.rbenv

# Build and install rbenv
cd ~/.rbenv
echo "Building and installing rbenv..."
make
sudo make install

# Set up rbenv in your shell
echo "Setting up rbenv in your shell..."
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# Reload your shell configuration
echo "Reloading shell configuration..."
source ~/.bashrc

# Go back to the home directory
cd ~

# Download and install ruby-build plugin
echo "Downloading and installing ruby-build plugin..."
wget -q https://github.com/rbenv/ruby-build/archive/refs/tags/v20250610.tar.gz
tar -xzf v20250610.tar.gz
mkdir -p ~/.rbenv/plugins
mv ruby-build-*/ ~/.rbenv/plugins/ruby-build

# Source .bashrc to apply changes immediately
echo "Sourcing .bashrc..."
source ~/.bashrc
echo ".bashrc has been sourced. Your environment is updated."

# Install Ruby 3.4.4
echo "Installing Ruby 3.4.4..."
rbenv install 3.4.4
rbenv global 3.4.4

# Install Ruby development headers and other dependencies
echo "Installing Ruby development headers and other dependencies..."
sudo apt-get update
sudo apt-get -qq -y install ruby-dev ruby-full ruby-all-dev ruby-ansi curl

# Cleanup
echo "Cleaning up temporary files..."
cd ~
rm -rf v20250610.tar.gz ruby-build-* ~/.rbenv/ruby-build

# Final message
echo "Installation complete! Ruby 3.4.4 is now installed and set as the global version."

