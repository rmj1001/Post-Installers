#!/usr/bin/env bash

function FINDCMD() {
    [[ -x "$(command -v ${1})" ]] && return 0
    return 1
}
function PRINT() { printf "%b\n" "${@}"; }

FINDCMD "dnf" || FINDCMD "apt" || FINDCMD "zypper" || {
    PRINT "postinstall: 'doas' not supported for your distro."
    exit 1
}

FINDCMD "dnf" &&
    sudo dnf install gcc gcc-c++ make flex bison pam-devel byacc

FINDCMD "apt" &&
    sudo apt install build-essential make bison flex libpam0g-dev

FINDCMD "zypper" &&
    sudo zypper install gcc gcc-c++ make flex bison pam-devel byacc git

mkdir ~/.local/share/com.github.rmj1001.Post-Installers.git-repos
cd ~/.local/share/com.github.rmj1001.Post-Installers.git-repos

git clone https://github.com/slicer69/doas.git
cd ./doas

make
sudo make install
sudo cp /etc/pam.d/sudo /etc/pam.d/doas
PRINT "Doas installed! Run 'sudo vidoas' to edit the config file."
PRINT "Make sure to type 'permit $USER as root'."
