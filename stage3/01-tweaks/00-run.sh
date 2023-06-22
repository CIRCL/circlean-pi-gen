#!/bin/bash -e

# sudo ./install_python3.10.sh
on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_boot_wait 1
EOF
