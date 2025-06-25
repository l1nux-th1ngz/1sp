#!/bin/bash

echo "Picom is not installed. Installing..."


sudo apt-get -y install libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev 
sudo apt-get -y install libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev
sudo apt-get -y install libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev

git clone https://github.com/FT-Labs/picom
cd picom
meson setup --buildtype=release build
ninja -C build
sudo ninja -C build install

mkdir -p ~/.config/picom
touch ~/.config/picom/picom.conf


echo "Installation complete."
