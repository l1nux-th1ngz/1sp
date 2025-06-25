#!/usr/bin/env bash
set -e

# --- Bash Completion Setup ---

echo "Installing bash-completion..."
sudo apt-get -y install bash-completion

# Ensure bash completion is enabled in ~/.bashrc
if ! grep -wq 'bash_completion' ~/.bashrc; then
    echo "Configuring ~/.bashrc for bash-completion..."
    cat << 'EOF' >> ~/.bashrc

# Enable bash completion if available
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
EOF
fi

# Source bashrc to apply changes immediately
echo "Sourcing ~/.bashrc..."
source ~/.bashrc

# Optional: ensure /etc/profile.d/bash_completion.sh is sourced
if ! grep -wq 'source /etc/profile.d/bash_completion.sh' ~/.bashrc; then
    echo "Adding source for /etc/profile.d/bash_completion.sh to ~/.bashrc..."
    echo 'source /etc/profile.d/bash_completion.sh' >> ~/.bashrc
    source /etc/profile.d/bash_completion.sh
fi

# --- Zsh Installation and Configuration ---

echo "Installing Zsh and essential plugins..."
sudo apt-get install -y zsh zsh-common zsh-autosuggestions zsh-syntax-highlighting zsh-theme-powerlevel9k

# Prompt user to edit ~/.zshrc
echo -e "\nYou may now customize your ~/.zshrc as needed."
echo "Run 'zsh' to create or edit your .zshrc."
read -p "Press ENTER after editing ~/.zshrc to continue..."

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Clone plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Cloning zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
    echo "Cloning zsh-completions..."
    git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
fi

# Update plugins list
if grep -q '^plugins=' "$HOME/.zshrc"; then
    sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-completions)/' "$HOME/.zshrc"
else
    echo 'plugins=(git zsh-autosuggestions zsh-completions)' >> "$HOME/.zshrc"
fi

# Append configuration for zsh-completions
if ! grep -q 'zsh-completions/src' "$HOME/.zshrc"; then
    cat << 'EOF' >> "$HOME/.zshrc"

# Enable zsh-completions
fpath+=("$ZSH_CUSTOM/plugins/zsh-completions/src")
autoload -U compinit && compinit
EOF
fi

# Source ~/.zshrc
echo "Sourcing ~/.zshrc..."
source "$HOME/.zshrc"

# Reboot 
echo "Installation and configuration complete."
read -p "Press ENTER to reboot or Ctrl+C to cancel." 
sudo reboot
