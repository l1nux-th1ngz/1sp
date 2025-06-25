#!/usr/bin/env bash
set -e

echo "Installing Zsh and essential plugins..."
sudo apt-get install -y zsh zsh-common zsh-autosuggestions zsh-syntax-highlighting \
  zsh-theme-powerlevel9k

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Prompt user to edit .zshrc before continuing
echo -e "\nYou may now customize your ~/.zshrc as needed."
read -p "Press ENTER to continue after you're done editing .zshrc..."

# Add autosuggestions and completions plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"

# Ensure plugins line exists and includes the new ones
sed -i '/^plugins=/c\plugins=(git zsh-autosuggestions zsh-completions)' "$HOME/.zshrc"

# Optional: append fpath and load completions
cat << 'EOF' >> "$HOME/.zshrc"

# Enable zsh-completions
fpath+=("$ZSH_CUSTOM/plugins/zsh-completions/src")
autoload -U compinit && compinit
EOF

# Source the config
echo "Sourcing ~/.zshrc..."
source "$HOME/.zshrc"

read -p "Install and config complete. Press ENTER to reboot or Ctrl+C to cancel."
sudo reboot
