#!/bin/bash

wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.46.0/fastfetch-linux-amd64.deb
sudo dpkg -i fastfetch-linux-amd64.deb
rm fastfetch-linux-amd64.deb

sudo apt-get update
sudo apt-get -y install synaptic packagekit packagekit-tools appstream deborphan apt-xapian-index apt-file

sudo mv -f synaptic-pkexec /usr/bin/
sudo chmod +x /usr/bin/synaptic-pkexec

sudo mv -f synaptic /usr/sbin/
sudo chmod +x /usr/sbin/synaptic

sudo mv -f synaptic.desktop /usr/share/applications/
sudo chmod +x /usr/share/applications/synaptic.desktop
