#!/bin/bash

chmod +x *.sh

rm -rf 1sp

echo "Operations completed successfully."

# Function to execute a script and check for errors
run_script() {
    local script_name="$1"
    local use_sudo="$2"

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

# Execute each script in sequence
run_script "zsh_debian.sh" false
run_script "usenala.sh" true
run_script "bports.sh" false
run_script "charm-repo.sh" false
run_script "langs.sh" false
run_script "go124.sh" false
run_script "rust.sh" false
run_script "jq.sh" false
run_script "ruby.sh" false
run_script "nano.sh" false
run_script "polkit.sh" false
run_script "display-servers.sh" false
run_script "dg.sh" false

echo "All scripts executed successfully!"
