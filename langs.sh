#!/bin/bash

echo "🔧 Starting setup..."

# Update
sudo apt-get -qq update

# Python and Python Libs
sudo apt-get -qq -y install \
  python3-full python3-dev python3-setuptools python3-pil python3-typing-extensions \
  python3-opencv python3-boto3 python3-pyocr python3-gv python3-tabulate \
  python3-all-dev python3-opencv-apps python3-boto python-is-python3 black \
  python3-jinja2 python3-shellingham tesseract-ocr python3-pyperclip python3-six \
  python3-colorama python3-yaml libreadline-dev libreadline8 readline-common \
  python3-click python3-click-completion python3-rich python3-aalib python3-mako \
  python3-scapy python3-chardet python3-html2text python3-pytools python3-qrcode \
  python3-unidecode ruby-asciidoctor python3-sh python3-zstd uxplay gir1.2-vte-2.91 \
  python3-requests python3-requests-file python3-ipython ipython3 gir1.2-keybinder-3.0  \
  python3-cryptography python3-cryptography-vectors python3-matplotlib python3-pyx \
  python3-cairocffi python3-cairosvg python3-gi python3-gi-cairo python3-scipy \
  python3-sip python3-tornado python3-twisted python3-pampy python3-pycurl \
  python3-serial python3-wxgtk python3-parallel python3-psutil python3-configobj \
  python3-distutils python3-tk python3-wxgtk-media4.0 python3-wxgtk-webview4.0

# Java
sudo apt-get -qq -y install \
  default-jre default-jre-headless default-jdk-headless default-jdk

wget -q --show-progress https://download.oracle.com/java/24/latest/jdk-24_linux-x64_bin.deb
wget -q --show-progress https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb

sudo dpkg -i jdk-21_linux-x64_bin.deb || { echo "❌ JDK 21 install failed"; exit 1; }
sleep 3
sudo dpkg -i jdk-24_linux-x64_bin.deb || { echo "❌ JDK 24 install failed"; exit 1; }
sleep 3

rm -f jdk-21_linux-x64_bin.deb jdk-24_linux-x64_bin.deb

# Perl
sudo apt-get -qq -y install \
  perl-base perl perl-modules-5.36 perl-openssl-defaults perlmagick rename pkg-perl-tools \
  libprogress-any-output-termprogressbarcolor-perl libcache-cache-perl \
  libdebian-package-html-perl libconfig-model-dpkg-perl libnet-ldap-perl \
  liblocale-gettext-perl libgtk3-perl libterm-readline-gnu-perl weblint-perl

# Ruby
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
~/.rbenv/bin/rbenv init || echo "⚠️ rbenv init failed"

wget -q https://github.com/rbenv/ruby-build/archive/refs/tags/v20250610.tar.gz
tar -xzf v20250610.tar.gz
PREFIX=/usr/local ./ruby-build-*/install.sh
\curl -sSL https://get.rvm.io | bash -s stable

~/.rbenv/bin/rbenv install 3.44 || echo "⚠️ Ruby 3.44 install failed"

sudo apt-get -qq -y install \
  ruby-dev ruby-full ruby-all-dev ruby-ansi curl

# NodeJS
sudo apt-get -qq -y install \
  npm node-tap node-opener nodejs node-latest-version node-semver \
  node-rollup-plugin-commonjs node-rollup-plugin-json node-rollup-plugin-node-polyfills \
  node-rollup-plugin-sass node-rollup-plugin-typescript node-rollup-plugin-typescript2 \
  node-rollup-pluginutils node-chokidar node-chownr pkg-js-tools

npm cache clean --force
sudo npm install -g npm@latest

# Lua and LuaRocks
(
  curl -O https://www.lua.org/ftp/lua-5.4.8.tar.gz && \
  tar zxf lua-5.4.8.tar.gz && \
  cd lua-5.4.8 && make all test && sudo make install
)

(
  wget -q https://luarocks.org/releases/luarocks-3.12.1.tar.gz && \
  tar zxpf luarocks-3.12.1.tar.gz && \
  cd luarocks-3.12.1 && \
  ./configure --with-lua-include=/usr/local/include && \
  make && sudo make install && \
  sudo luarocks install luasocket
)

# Miscellaneous tools
sudo apt-get -qq -y install php-codesniffer pylint

# Cleanup
rm -rf lua-5.4.8 luarocks-3.12.1 ruby-build-* \
       *.tar.gz *.deb

# Final Update
sudo apt-get -qq update

echo "✅ Done — system is loaded and ready."
