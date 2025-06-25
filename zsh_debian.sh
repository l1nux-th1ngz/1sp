#!/usr/bin/env bash
set -euo pipefail

# --- Bash Completion Setup ---
echo "Installing bash-completion..."
sudo apt-get -y install bash-completion

if ! grep -q 'bash_completion' ~/.bashrc; then
    echo "Adding bash-completion config to ~/.bashrc..."
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

if ! grep -q 'source /etc/profile.d/bash_completion.sh' ~/.bashrc; then
    echo "Adding fallback bash_completion.sh to ~/.bashrc..."
    echo 'source /etc/profile.d/bash_completion.sh' >> ~/.bashrc
fi

# --- Zsh Installation and Configuration ---
echo "Installing Zsh and plugins..."
sudo apt-get install -y zsh zsh-common zsh-autosuggestions zsh-syntax-highlighting zsh-theme-powerlevel9k

touch ~/.zshrc

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

[[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] &&
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]] &&
    git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"

if grep -q '^plugins=' ~/.zshrc; then
    sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-completions)/' ~/.zshrc
else
    echo 'plugins=(git zsh-autosuggestions zsh-completions)' >> ~/.zshrc
fi

if ! grep -q 'zsh-completions/src' ~/.zshrc; then
    cat << 'EOF' >> ~/.zshrc

# Enable zsh-completions
fpath+=("$ZSH_CUSTOM/plugins/zsh-completions/src")
autoload -U compinit && compinit
EOF
fi

echo "Configuration complete. Please restart your terminal session to activate changes."
