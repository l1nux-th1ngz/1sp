#!/bin/bash

# Make all .sh files executable
chmod +x *.sh

# Remove the specified directory only if it exists
DIR="1sp"
if [ -d "$DIR" ]; then
    rm -rf "$DIR"
    echo "Unneeded directory '$DIR' removed successfully."
else
    echo "Directory '$DIR' not found; skipping removal."
fi

# Function to execute a script and check for errors
run_script() {
    local script_name="$1"
    local use_sudo="$2"

    if [ ! -f "$script_name" ]; then
        echo "Warning: $script_name not found; skipping."
        return
    fi

    echo "Running $script_name..."
    if [ "$use_sudo" == "true" ]; then
        if ! sudo sh "$script_name"; then
            echo "Error: $script_name failed to execute."
            exit 1
        fi
    else
        if ! sh "$script_name"; then
            echo "Error: $script_name failed to execute."
            exit 1
        fi
    fi
}

# Array of scripts with sudo flags (true/false)
scripts=(
    "usenala.sh:true"
    "zsh_debian.sh:false"
    "bports.sh:false"
    "charm-repo.sh:false"
    "langs.sh:false"
    "go124.sh:false"
    "rust.sh:false"
    "jq.sh:false"
    "ruby.sh:false"
    "nano.sh:false"
    "polkit.sh:false"
    "display-servers.sh:false"
    "dg.sh:false"
)

# Execute scripts with apt update in between
for entry in "${scripts[@]}"; do
    IFS=":" read -r script use_sudo <<< "$entry"
    run_script "$script" "$use_sudo"
    sudo apt-get update -qq
done

echo "All scripts executed successfully!"
