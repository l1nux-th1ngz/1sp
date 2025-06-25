#!/bin/bash

set -e

echo "🔧 Setting up rbenv..."

# Define rbenv and plugin directories
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"

# Clone rbenv if not already present
if [ ! -d "$RBENV_ROOT" ]; then
    git clone https://github.com/rbenv/rbenv.git "$RBENV_ROOT"
    echo "✅ rbenv cloned."
fi

# Initialize rbenv in shell
if ! grep -q 'rbenv init' ~/.bashrc; then
    {
        echo 'export PATH="$HOME/.rbenv/bin:$PATH"'
        echo 'eval "$(rbenv init -)"'
    } >> ~/.bashrc
    echo "✅ rbenv initialization appended to .bashrc"
fi

# Apply changes immediately
eval "$(rbenv init -)"
source ~/.bashrc

# Install ruby-build plugin
PLUGIN_DIR="$RBENV_ROOT/plugins"
mkdir -p "$PLUGIN_DIR"

if [ ! -d "$PLUGIN_DIR/ruby-build" ]; then
    git clone https://github.com/rbenv/ruby-build.git "$PLUGIN_DIR/ruby-build"
    echo "✅ ruby-build plugin installed."
fi

# Install dependencies
echo "📦 Installing Ruby dependencies..."
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev zlib1g-dev libreadline-dev curl

# Pick the latest stable Ruby version
LATEST_VERSION=$(rbenv install -l | grep -E "^\s*[0-9]+\.[0-9]+\.[0-9]+$" | tail -1 | tr -d ' ')

echo "💎 Installing Ruby $LATEST_VERSION..."
rbenv install -s "$LATEST_VERSION"
rbenv global "$LATEST_VERSION"
rbenv rehash

echo "🎉 Ruby $LATEST_VERSION has been successfully installed and set as the global version."
