#!/bin/bash

set -e

# Define real user
real_user="${SUDO_USER:-$(logname)}"
real_home="/home/$real_user"

echo "🧩 Installing LightDM and GTK greeter..."
sudo apt-get update
sudo apt-get -y install lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings

echo "🛠️ Creating bspwm session launcher..."
sudo tee /usr/bin/bspwm-session > /dev/null << 'EOF'
#!/bin/bash
exec bspwm
EOF
chmod +x /usr/bin/bspwm-session

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
chown "$real_user:$real_user" /usr/bin/bspwm-session /usr/share/xsessions/bspwm.desktop

echo "🚀 Restarting LightDM to apply changes..."
systemctl restart lightdm



