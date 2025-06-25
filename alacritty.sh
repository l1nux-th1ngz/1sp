#!/bin/bash

# Clone the Alacritty repository
git clone https://github.com/alacritty/alacritty.git
cd alacritty

# Build with support only for X11
cargo build --release --no-default-features --features=x11

# Install the binary
sudo cp target/release/alacritty /usr/local/bin/

# Install the logo icon
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg

# Install desktop entry
sudo desktop-file-install extra/linux/Alacritty.desktop

# Update desktop database
sudo update-desktop-database

# Set up Zsh functions directory
mkdir -p "${ZDOTDIR:-~}/.zsh_functions"
echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> "${ZDOTDIR:-~}/.zshrc"

# Copy Zsh completion script
cp extra/completions/_alacritty "${ZDOTDIR:-~}/.zsh_functions/"

# Set up Bash completion
mkdir -p ~/.bash_completion
cp extra/completions/alacritty.bash ~/.bash_completion/alacritty
echo "source ~/.bash_completion/alacritty" >> ~/.bashrc


# Cleanup
cd ..
rm -f alacritty

echo "done"
