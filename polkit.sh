#!/bin/bash
set -e

echo "Installing user account utilities..."
sudo apt-get -y install passwd base-passwd accountsservice adduser coreutils \
base-files bsdutils dash debianutils diffutils findutils grep gzip hostname \
init-system-helpers libc-bin login ncurses-base ncurses-bin perl-base sed \
sysvinit-utils tar util-linux

echo "Installing Polkit components..."
sudo apt-get -y install \
  policykit-1 polkitd  libpolkit-gobject-1-dev libpolkit-gobject-1-0 \
  libpolkit-agent-1-0 libpolkit-agent-1-dev gir1.2-polkit-1.0 policykit-1-gnome \
  pkexec

echo "Polkit components installed successfully."
