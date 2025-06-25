#!/bin/bash

echo "Starting installation..."

# Install Kitty terminal emulator
echo "Installing Kitty..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Create symbolic links in ~/.local/bin for easier access
echo "Creating symbolic links..."
mkdir -p ~/.local/bin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty
ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/kitten

# Ensure ~/.local/bin is in PATH (add if not)
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
  source ~/.bashrc
fi

# Copy Kitty desktop files for desktop environment integration
echo "Configuring desktop files..."
mkdir -p ~/.local/share/applications
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/

# Update icon path in the desktop files
sed -i "s|Icon=kitty|Icon=$(readlink -f ~/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png)|g" ~/.local/share/applications/kitty*.desktop

# Update Exec path in desktop files
sed -i "s|Exec=kitty|Exec=$(readlink -f ~/.local/kitty.app/bin/kitty)|g" ~/.local/share/applications/kitty*.desktop

# Register Kitty as default terminal in xdg-terminals.list
echo 'kitty.desktop' > ~/.config/xdg-terminals.list

echo "Installation and configuration complete!"
