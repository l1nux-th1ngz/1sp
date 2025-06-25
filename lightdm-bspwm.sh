#!/bin/bash

set -e

# Define real user
real_user="${SUDO_USER:-$(logname)}"
real_home="/home/$real_user"

# Check if the user is root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo."
    exit 1
fi

# Check if bspwm is installed
if ! command -v bspwm &> /dev/null; then
    echo "BSPWM is not installed. Please install it before running this script."
    exit 1
fi

echo "🧩 Installing LightDM and GTK greeter..."
sudo apt-get update
sudo apt-get -y install lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings

echo "🛠️ Creating bspwm session launcher..."
sudo tee /usr/bin/bspwm-session > /dev/null << 'EOF'
#!/bin/bash
exec bspwm
EOF
sudo chmod +x /usr/bin/bspwm-session

echo "📝 Registering bspwm session with LightDM..."
sudo tee /usr/share/xsessions/bspwm.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=BSPWM
Comment=BSP window manager session
Exec=/usr/bin/bspwm-session
Type=Application
EOF

echo "⚙️ Writing LightDM bspwm config override..."
sudo mkdir -p /etc/lightdm/lightdm.conf.d
sudo tee /etc/lightdm/lightdm.conf.d/50-bspwm.conf > /dev/null << 'EOF'
[Seat:*]
user-session=bspwm
greeter-hide-users=false
greeter-allow-guest=true
autologin-guest=true
allow-user-switching=true
EOF

echo "🔄 Setting ownership..."
sudo chown "$real_user:$real_user" /usr/bin/bspwm-session /usr/share/xsessions/bspwm.desktop

echo "🚀 Restarting LightDM to apply changes..."
sudo systemctl restart lightdm
