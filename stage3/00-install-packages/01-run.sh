#!/bin/bash -e

install -m 644 files/rc-local.service "${ROOTFS_DIR}/etc/systemd/system/"
install -m 644 files/rc.local "${ROOTFS_DIR}/etc/"

on_chroot << EOF


sudo sed -i 's/#deb-src/deb-src/' /etc/apt/sources.list

apt-get update -y
apt-get remove hardlink -y
apt-get install util-linux -y
sudo apt install raspi-config -y

# Build and install p7zip-rar
cd /home/pi

mkdir -p /home/pi/rar
cd rar/
pwd
apt-get update
apt-get build-dep -y p7zip-rar
apt-get source -b p7zip-rar

echo "dpkg -i"
sudo dpkg -i p7zip-rar_16.02-3_armhf.deb

# Clone PyCIRCLean repository
cd /home/pi
rm -rf PyCIRCLean
git clone https://github.com/CIRCL/PyCIRCLean.git
echo "Cloning into PyCIRCLean"

echo "Installing Libreoffice"
yes | apt install libreoffice
cd PyCIRCLean/


echo "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.bashrc
source "$HOME/.cargo/env"


echo "checking the versions of pip and setuptools/upgrading them"
pip install --upgrade setuptools
pip install --upgrade pip




#echo "Installing Poetry"
#curl -sSL https://install.python-poetry.org > foo.py
#python3 foo.py
echo "Installing Poetry with pip"
cryptography==3.1.1
pip install poetry

echo "step 1"
echo $VENV_DIR
echo "ENV: $ENV_DIR"
python3 -m venv $VENV_PATH
echo "step 2"
$VENV_PATH/bin/pip install -U pip setuptools
echo "step 3"
$VENV_PATH/bin/pip install poetry
echo "done"

poetry install

# Additional setup steps specific to CIRCLean
useradd -m kitten
chown -R kitten:kitten /home/kitten

systemctl enable rc-local.service

systemctl disable networking.service
systemctl disable bluetooth.service
systemctl disable dhcpcd.service

# Cleanup
apt-get clean
apt-get autoremove -y
apt-get autoclean -y


EOF
