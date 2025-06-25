#!/bin/bash

# Install nala and check if it's successful
if ! sudo apt-get -y install nala; then
    echo "❌ Failed to install nala. Aborting."
    exit 1
fi

# Identify the first non-system user (excluding nologin/sync users)
username=$(getent passwd {1000..1100} | grep -vE 'nologin|false' | cut -d: -f1 | head -n1)
userhome=$(eval echo "~$username")

usenala="$userhome/.use-nala"
rusenala="/root/.use-nala"
ubashrc="$userhome/.bashrc"
rbashrc="/root/.bashrc"

# User-level nala wrapper
if [ ! -f "$usenala" ]; then
    cat << 'EOF' > "$usenala"
apt() {
  command nala "$@"
}
sudo() {
  if [ "$1" = "apt" ]; then
    shift
    command sudo nala "$@"
  else
    command sudo "$@"
  fi
}
EOF
    echo "[ -f \"$usenala\" ] && . \"$usenala\"" >> "$ubashrc"
    chmod +x "$usenala"
    sudo -u "$username" bash -c "source \"$ubashrc\""
fi

# Root-level nala wrapper
if [ ! -f "$rusenala" ]; then
    cat << 'EOF' > "$rusenala"
apt() {
  command nala "$@"
}
EOF
    echo "[ -f \"$rusenala\" ] && . \"$rusenala\"" >> "$rbashrc"
    chmod +x "$rusenala"
    source "$rbashrc"
fi

echo "✅ Nala wrapper installed and configured for user and root environments."
