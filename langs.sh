#!/bin/bash

set -euo pipefail
echo "🔧 Starting setup..."

# Update
sudo apt-get -qq update

# --- Python & Libraries ---
echo "📦 Installing Python and libraries..."
sudo apt-get -qq -y install \
  python3-full python3-dev python3-setuptools python3-pil python3-typing-extensions \
  python3-opencv python3-boto3 python3-pyocr python3-gv python3-tabulate \
  python3-all-dev python3-opencv-apps python3-boto python-is-python3 black \
  python3-jinja2 python3-shellingham tesseract-ocr python3-pyperclip python3-six \
  python3-colorama python3-yaml libreadline-dev libreadline8 readline-common \
  python3-click python3-click-completion python3-rich python3-aalib python3-mako \
  python3-scapy python3-chardet python3-html2text python3-pytools python3-qrcode \
  python3-unidecode ruby-asciidoctor python3-sh python3-zstd uxplay gir1.2-vte-2.91 \
  python3-requests python3-requests-file python3-ipython ipython3 gir1.2-keybinder-3.0 \
  python3-cryptography* python3-matplotlib python3-pyx python3-cairocffi \
  python3-cairosvg python3-gi python3-gi-cairo python3-scipy python3-sip \
  python3-tornado python3-twisted python3-pampy python3-pycurl python3-serial \
  python3-wxgtk4.0 python3-parallel python3-psutil python3-configobj \
  python3-distutils python3-tk python3-wxgtk-media4.0 python3-wxgtk-webview4.0

# --- Java (Default + Oracle JDKs) ---
echo "☕ Installing Java..."
sudo apt-get -qq -y install default-jre default-jre-headless default-jdk-headless default-jdk

jdk_versions=(21 24)
for ver in "${jdk_versions[@]}"; do
  deb="jdk-${ver}_linux-x64_bin.deb"
  url="https://download.oracle.com/java/${ver}/latest/$deb"
  wget -q --show-progress "$url" && \
  sudo dpkg -i "$deb" || echo "❌ JDK $ver install failed"
  sleep 2
done

rm -f jdk-*_linux-x64_bin.deb

# --- Perl Environment ---
echo "🧬 Installing Perl and modules..."
sudo apt-get -qq -y install \
  perl-base perl perl-modules-5.36 perl-openssl-defaults perlmagick rename pkg-perl-tools \
  libprogress-any-output-termprogressbarcolor-perl libcache-cache-perl \
  libdebian-package-html-perl libconfig-model-dpkg-perl libnet-ldap-perl \
  liblocale-gettext-perl libgtk3-perl libterm-readline-gnu-perl weblint-perl

# --- Node.js & NPM ---
echo "📦 Installing Node.js and NPM..."
sudo apt-get -qq -y install \
  npm node-tap node-opener nodejs node-latest-version node-semver \
  node-rollup-plugin-* node-chokidar node-chownr pkg-js-tools

sudo npm cache clean --force
sudo npm install -g npm@latest

# --- Lua & LuaRocks ---
echo "🔮 Building Lua 5.4.8..."
(
  curl -sSLO https://www.lua.org/ftp/lua-5.4.8.tar.gz && \
  tar zxf lua-5.4.8.tar.gz && cd lua-5.4.8 && make all test && sudo make install
)

cd ..

echo "🔮 Installing LuaRocks..."
(
  curl -sSLO https://luarocks.org/releases/luarocks-3.12.1.tar.gz && \
  tar zxpf luarocks-3.12.1.tar.gz && cd luarocks-3.12.1 && \
  ./configure --with-lua-include=/usr/local/include && make && sudo make install && \
  sudo luarocks install luasocket
)

cd ..

# --- Linting & Code Check Tools ---
sudo apt-get -qq -y install php-codesniffer pylint

# --- Cleanup ---
rm -rf lua-5.4.8 luarocks-3.12.1 *.tar.gz

# Final update
sudo apt-get -qq update
echo "✅ Done — system is loaded and ready."
