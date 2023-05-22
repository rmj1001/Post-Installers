#!/usr/bin/env bash

##############################################
#   Author: RMCJ <rmichael1001@gmail.com>
#   Project: Ubuntu postinstall
#   Version: 1.0
#
#   Usage: ubuntu.sh
#
#   Description:
#		Curlable ubuntu post-install script
##############################################

[[ $EUID -eq 0 ]] && {
	PROGRAM_NAME="$(basename "$0")"

	printf '%b' "'${PROGRAM_NAME}' should not be run as root. "
	printf '%b\n' "Please try again as a normal user."
	exit 1
}

[[ -x "$(which apt)" ]] || {
	printf '%b\n' "This script must be run on Ubuntu."
	exit 1
}

function ctrl_c() {
	printf "%b\n" "\n"
	[[ -z "${scriptNumber}" ]] && printf "%b\n" "Canceling."
	printf "%b\n"
	exit 0
}

trap ctrl_c INT

################################################################################
# ENVIRONMENT VARIABLES
#

HELPERS="https://raw.githubusercontent.com/rmj1001/HeckerShell/main/files/Postinstallers/helpers"

################################################################################
# REPOSITORY SETUP
#

# Install repositories/ppas
ppas=(
	"ppa:lutris-team/lutris"
	"multiverse"
)

for ppa in "${ppas[@]}"; do

	sudo add-apt-repository -y -n "${ppa}"

done

sudo apt update

################################################################################
# SOFTWARE INSTALLATION
#

# Install common packages
sudo apt install \
	lutris \
	steam-installer \
	build-essential \
	meson \
	libsystemd-dev \
	pkg-config \
	ninja-build \
	git \
	libdbus-1-dev \
	libinih-dev \
	ubuntu-restricted-extras

################################################################################
# REBOOT
#

printf '%b' "Reboot? (Y/n) " && read -r reboot
[[ -z "${reboot}" || "${reboot}" =~ ^[yY][eE]?[sS]?$ ]] && systemctl reboot
