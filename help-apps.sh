#!/bin/bash

set -e

echo "[*] Updating package list..."
sudo apt-get update

echo "[*] Installing required packages..."
sudo apt-get install -y \
  libpcap0 graphviz libgraphviz-dev gsfonts fonts-liberation2 cm-super-minimal dvipng \
  fonts-staypuft ghostscript texlive-fonts-recommended tipa tex-gyre fonts-texgyre \
  fonts-texgyre-math tex-common debhelper dh-make librsvg2-common libcurl4-gnutls-dev \
  dh-python dpkg dpkg-dev python3-build python3-install sox tcpdump tcpreplay dhcpig \
  netdiscover ipwatchd nmap net-tools iproute2 moreutils libxrender-dev libxrender1
