#!/bin/bash

# Install polybar
sudo apt-get -y install polybar

# Create configuration directory
mkdir -p ~/.config/polybar

# Copy default config if it doesn't already exist
if [ ! -f ~/.config/polybar/config.ini ]; then
    cp /etc/polybar/config.ini ~/.config/polybar/
fi

# Create the launch script
cat > ~/.config/polybar/launch.sh << 'EOF'
#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar &
EOF

# Make the launch script executable
chmod +x ~/.config/polybar/launch.sh
