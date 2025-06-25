#!/bin/bash

# This script must be run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

# Get non-root user with UID 1000
username=$(getent passwd 1000 | cut -d: -f1)
if [ -z "$username" ]; then
    echo "No user found with UID 1000"
    exit 1
fi

# Define user and root paths
usenala="/home/$username/.use-nala"
ubashrc="/home/$username/.bashrc"
rusenala="/root/.use-nala"
rbashrc="/root/.bashrc"

# Function to safely append a line if not already present
append_if_missing() {
    local line="$1"
    local file="$2"
    grep -qxF "$line" "$file" || echo "$line" >> "$file"
}

# Create user's nala wrapper if missing
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
    chown "$username:$username" "$usenala"
    chmod 644 "$usenala"
fi

# Ensure it's sourced in the user's .bashrc
append_if_missing "if [ -f \"$usenala\" ]; then . \"$usenala\"; fi" "$ubashrc"
chown "$username:$username" "$ubashrc"

# Create root's nala wrapper if missing
if [ ! -f "$rusenala" ]; then
    cat << 'EOF' > "$rusenala"
apt() {
  command nala "$@"
}
EOF
    chmod 644 "$rusenala"
fi

# Ensure it's sourced in root's .bashrc
append_if_missing "if [ -f \"$rusenala\" ]; then . \"$rusenala\"; fi" "$rbashrc"
