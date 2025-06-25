#!/bin/bash

set -e

echo "[+] Installing CMake..."
CMAKE_VER="4.0.3"
CMAKE_FILE="cmake-${CMAKE_VER}-linux-x86_64.sh"
wget -q "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VER}/${CMAKE_FILE}"
chmod +x "${CMAKE_FILE}"
sudo bash "${CMAKE_FILE}" --skip-license --prefix=/usr/local
rm "${CMAKE_FILE}"

echo "[+] Installing Ninja..."
wget -qO /tmp/ninja-linux.zip "https://github.com/ninja-build/ninja/releases/latest/download/ninja-linux.zip"
unzip -q /tmp/ninja-linux.zip -d /tmp/ninja
sudo mv /tmp/ninja/ninja /usr/local/bin/
sudo chmod a+x /usr/local/bin/ninja
rm /tmp/ninja-linux.zip
rm -rf /tmp/ninja

echo "[+] Fetching and building GCC..."
GCC_TAG="gcc-15.1.0"
GCC_DIR="gcc-${GCC_TAG}"
wget -q "https://github.com/gcc-mirror/gcc/archive/refs/tags/${GCC_TAG}.tar.gz" -O "${GCC_DIR}.tar.gz"
tar -xf "${GCC_DIR}.tar.gz"
cd "${GCC_DIR}"

# Install dependencies for building GCC (example, may vary)
sudo apt-get update
sudo apt-get install -y libgmp-dev libmpfr-dev libmpc-dev zlib1g-dev

# Create build directory
mkdir build && cd build
../configure --prefix=/usr/local/gcc --enable-languages=c,c++ --disable-multilib
make -j"$(nproc)"
sudo make install

# Cleanup
cd ../..
rm -rf "${GCC_DIR}" "${GCC_DIR}.tar.gz"

echo "[+] All installations complete."

