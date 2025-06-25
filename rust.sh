#!/bin/bash

# Install Rust using rustup with minimal profile and nightly toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal --default-toolchain nightly

# Add Cargo bin to PATH for the current session
export PATH="$HOME/.cargo/bin:$PATH"

# Source the appropriate shell config based on current shell
case "$SHELL" in
  */bash) source "$HOME/.bashrc" ;;
  */zsh)  source "$HOME/.zshrc" ;;
esac

# Update Rust toolchains
rustup update

# Enable shell completions

# Bash completion
mkdir -p ~/.local/share/bash-completion/completions
rustup completions bash > ~/.local/share/bash-completion/completions/rustup

# Zsh completion
mkdir -p ~/.zfunc
rustup completions zsh > ~/.zfunc/_rustup

# Ensure fpath+=~/.zfunc exists before compinit in ~/.zshrc
if ! grep -qxF 'fpath+=~/.zfunc' "$HOME/.zshrc"; then
  echo 'fpath+=~/.zfunc' >> "$HOME/.zshrc"
fi

# Final message
echo "Rust installation and completions setup complete."
echo "Please restart your shell or source your configuration files to apply changes."
