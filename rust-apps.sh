#!/bin/bash

set -e  # Exit immediately on error

# Check for required commands
for cmd in git cargo curl wget python3; do
  if ! command -v $cmd &>/dev/null; then
    echo "Error: $cmd is not installed." >&2
    exit 1
  fi
done

# Install Viu image previewer
echo "Installing Viu..."
git clone https://github.com/atanunq/viu.git
cd viu
cargo install --path .
cd .. && rm -rf viu

# Install Awrit browser
echo "Installing Awrit..."
curl -fsS https://chase.github.io/awrit/get | bash

# Install Yazi file manager
echo "Installing Yazi..."
cargo install --locked yazi-fm yazi-cli
git clone https://github.com/sxyazi/yazi.git
cd yazi
cargo build --release --locked
sudo mv target/release/yazi /usr/local/bin/ya
cd ..
rm -rf yazi

# Install NNN file manager
echo "Installing NNN..."
wget https://github.com/jarun/nnn/releases/download/v5.1/nnn-v5.1.tar.gz
wget https://github.com/jarun/nnn/releases/download/v5.1/nnn-emoji-static-5.1.x86_64.tar.gz
wget https://github.com/jarun/nnn/releases/download/v5.1/nnn-icons-static-5.1.x86_64.tar.gz

tar -xzf nnn-v5.1.tar.gz
cd nnn-5.1
make
sudo make install
cd ..

tar -xzf nnn-emoji-static-5.1.x86_64.tar.gz
sudo mv nnn-emoji-static-5.1.x86_64 /usr/local/bin/

tar -xzf nnn-icons-static-5.1.x86_64.tar.gz
sudo mv nnn-icons-static-5.1.x86_64 /usr/local/bin/

# Install NNN plugins
echo "Installing NNN plugins..."
sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

# Install Ranger
echo "Installing Ranger..."
wget https://github.com/ranger/ranger/releases/download/v1.9.4/ranger-1.9.4.tar.gz
tar -xzf ranger-1.9.4.tar.gz
cd ranger-1.9.4
python3 setup.py install --user
cd ..
rm -rf ranger-1.9.4 ranger-1.9.4.tar.gz

# Cleanup
rm -f nnn-v5.1.tar.gz nnn-emoji-static-5.1.x86_64.tar.gz nnn-icons-static-5.1.x86_64.tar.gz yazi viu awrit

echo "Installation complete!"
