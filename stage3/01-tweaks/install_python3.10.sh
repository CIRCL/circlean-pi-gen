#!/bin/bash

set -e

# Update package lists
apt-get update

# Install dependencies
apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget

# Download Python 3.10 source code
wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tar.xz
tar -xf Python-3.10.0.tar.xz
cd Python-3.10.0

# Configure and build Python 3.10
./configure --enable-optimizations
make -j$(nproc)
make install

# Cleanup
cd ..
rm -rf Python-3.10.0 Python-3.10.0.tar.xz

# Verify Python installation
python3.10 --version
