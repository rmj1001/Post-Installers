#!/usr/bin/env bash

##############################################
#   Author: RMCJ <rmichael1001@gmail.com>
#   Project: Pyenv install helper
#   Version: 1.0
#
#   Usage: pyenv.sh
#
#   Description:
#		Install pyenv
##############################################

function CMD_EXISTS() {
    [[ -x "$(command -v "${1}")" ]] && return 0
    return 1
}

##############################################
# INSTALL DEPENDENCIES

CMD_EXISTS "xcode-select" && {
    brew install openssl readline sqlite3 xz zlib
}

CMD_EXISTS "brew" && {
    brew install bzip2 libffi libxml2 libxmlsec1 openssl readline sqlite xz zlib
}

CMD_EXISTS "apt" && {
    sudo apt-get update
    sudo apt-get install make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
}

CMD_EXISTS "dnf" && {
    dnf install make gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel
}

CMD_EXISTS "zypper" && {
    zypper install gcc automake bzip2 libbz2-devel xz xz-devel openssl-devel ncurses-devel \
        readline-devel zlib-devel tk-devel libffi-devel sqlite3-devel
}

CMD_EXISTS "pacman" && {
    pacman -S --needed base-devel openssl zlib xz
}

CMD_EXISTS "eopkg" && {
    sudo eopkg it -c system.devel
    sudo eopkg install git gcc make zlib-devel bzip2-devel readline-devel sqlite3-devel openssl-devel tk-devel
}

CMD_EXISTS "apk" && {
    apk add --no-cache git bash build-base libffi-dev openssl-dev bzip2-dev zlib-dev readline-dev sqlite-dev
}

CMD_EXISTS "xbps-install" && {
    xbps-install base-devel bzip2-devel openssl openssl-devel readline readline-devel sqlite-devel xz zlib zlib-devel
}

##############################################
# INSTALL PYENV

CMD_EXISTS "brew" && {
    brew update
    brew install pyenv
}

CMD_EXISTS "brew" || {
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    cd ~/.pyenv && src/configure && make -C src
}

##############################################
# CONFIGURE THE SHELL

[[ -f "${HOME}/.profile" ]] && {
    # the sed invocation inserts the lines at the start of the file
    # after any initial comment lines
    sed -Ei -e '/^([^#]|$)/ {a \
export PYENV_ROOT="$HOME/.pyenv"
a \
export PATH="$PYENV_ROOT/bin:$PATH"
a \
' -e ':a' -e '$!{n;ba};}' ~/.profile
    echo 'eval "$(pyenv init --path)"' >>~/.profile

    echo 'eval "$(pyenv init -)"' >>~/.bashrc
    exit 0
}

[[ -f "${HOME}/.bash_profile" ]] && {
    sed -Ei -e '/^([^#]|$)/ {a \
export PYENV_ROOT="$HOME/.pyenv"
a \
export PATH="$PYENV_ROOT/bin:$PATH"
a \
' -e ':a' -e '$!{n;ba};}' ~/.bash_profile
    echo 'eval "$(pyenv init --path)"' >>~/.bash_profile

    echo 'export PYENV_ROOT="$HOME/.pyenv"' >>~/.profile
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >>~/.profile
    echo 'eval "$(pyenv init --path)"' >>~/.profile

    echo 'eval "$(pyenv init -)"' >>~/.bashrc
    exit 0
}

# Checks for SUSE
CMD_EXISTS "zypper" && {
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >>~/.profile
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >>~/.profile
    echo 'eval "$(pyenv init --path)"' >>~/.profile

    echo 'if command -v pyenv >/dev/null; then eval "$(pyenv init -)"; fi' >>~/.bashrc
}

# Checks for MacOS
CMD_EXISTS "xcode-select" && {
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >>~/.profile
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >>~/.profile
    echo 'eval "$(pyenv init --path)"' >>~/.profile
    echo 'if [ -n "$PS1" -a -n "$BASH_VERSION" ]; then source ~/.bashrc; fi' >>~/.profile

    echo 'eval "$(pyenv init -)"' >>~/.bashrc
}
