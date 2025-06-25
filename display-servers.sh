#!/bin/bash

set -e
set -o pipefail

echo "Preparing system..."
sudo dpkg --add-architecture i386
sudo apt-get update

# Install Xorg packages
install_xorg() {
  echo "Installing Xorg packages..."
  sudo apt-get -y install \
    xorg xorg-dev xserver-xorg xserver-common xserver-xorg-core \
    xserver-xorg-input-all xserver-xorg-input-libinput xserver-xorg-legacy \
    xserver-xorg-video-all xserver-xorg-video-fbdev xserver-xorg-video-intel \
    xserver-xorg-video-nouveau xserver-xorg-video-qxl xserver-xorg-video-vesa \
    xserver-xorg-video-vmware xtrans-dev xserver-xephyr xauth \
    xserver-xorg-video-siliconmotion xrdp
}

# Install X11 packages
install_x11() {
  echo "Installing X11 packages..."
  sudo apt-get -y install \
    x11proto-dev x11-apps x11-common \
    x11-session-utils x11-utils x11-xkb-utils \
    x11-xserver-utils x11proto-core-dev dbus-x11 \
    dbus-user-session libx11-dev xinput xinit
}

# Install polkits
install_polkits() {
  echo "Installing polkits..."
  sudo apt-get -y install \
    policykit-1 polkitd pkexec libpolkit-gobject-1-dev libpolkit-gobject-1-0 \
    libpolkit-agent-1-0 libpolkit-agent-1-dev gir1.2-polkit-1.0 policykit-1-gnome
}

# Install firmware and drivers
install_firmware() {
  echo "Installing firmware and drivers..."
  sudo apt-get -y install \
    firmware-misc-nonfree initramfs-tools intel-microcode intel-media-va-driver \
    intel-media-va-driver:i386 intel-media-va-driver-non-free iucode-tool \
    libgl1-mesa-dri xcvt libxcvt0 libxcvt-dev xbacklight xbindkeys xvkbd \
    libnotify-bin libnotify-dev nickle cairo-5c
}

# Validate services and drivers
post_check() {
  echo "Validating system components..."
  command -v Xorg >/dev/null && echo "✓ Xorg is available"
  command -v xinit >/dev/null && echo "✓ X11 is available"
  command -v dbus-daemon >/dev/null && echo "✓ DBus is available"
  command -v pkexec >/dev/null && echo "✓ Polkit is available"
}

# Run all steps
install_xorg
install_x11
install_polkits
install_firmware
post_check

echo "All components installed and validated successfully."
