#!/bin/bash -e

install -m 644 files/rc-local.service "${ROOTFS_DIR}/etc/systemd/system/"
#install -m 644 files/.bashrc "${ROOTFS_DIR}/home/*"


on_chroot << EOF


sudo sed -i 's/#deb-src/deb-src/' /etc/apt/sources.list

apt-get update -y
apt-get remove hardlink -y
apt-get install util-linux -y
sudo apt install raspi-config -y

# Build and install p7zip-rar
echo "INSTALLING STUFF DONE, BUILDING AND INSTALLING P7ZIP"
cd /home/pi


mkdir -p /home/pi/rar
cd rar/
pwd
apt-get update
apt-get build-dep -y p7zip-rar
apt-get source -b p7zip-rar
ls
pwd


echo "dpkg -i"
sudo dpkg -i p7zip-rar_16.02-3_armhf.deb

# Clone PyCIRCLean repository
echo "P7ZIP DONE CLONING REPO"
cd /home/pi
PYCIRCL_DIR=/home/pi/PyCIRCLean/

if [ ! -d /home/pi/PyCIRCLean/ ]; then
    git clone https://github.com/CIRCL/PyCIRCLean.git
    echo "Cloning into PyCIRCLean"

fi
ls
pwd
cd PyCIRCLean/
echo "cd into pycriclean, it's installed btw, now installing python packages"
#pip3 install poetry
echo "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.bashrc
source "$HOME/.cargo/env"
echo "Installing Poetry"
curl -sSL https://install.python-poetry.org | python3 -
#export PATH="$HOME/.poetry/bin:$PATH"
echo "version"
#poetry --version
# Additional setup steps specific to CIRCLean


useradd -m kitten
chown -R kitten:kitten /home/kitten

#systemctl enable rc-local.service

#systemctl disable networking.service
#systemctl disable bluetooth.service
#systemctl disable dhcpcd.service

# Cleanup
apt-get clean
apt-get autoremove -y
apt-get autoclean -y

EOF

