<!--
##############################################
#   Author(s): RMCJ <rmichael1001@gmail.com>
#   Project: HeckerShell
#   Version: 1.0
#
#   Usage: n/a
#
#   Description: Distro post-install info
#
##############################################
-->
# Post-installation Scripts

The scripts in this directory install common software, repositories, and apply
common configurations for various Linux operating systems.

To install the software you want, copy the code and paste it into your terminal.

## Table of Contents

- [Post-installation Scripts](#post-installation-scripts)
  - [Table of Contents](#table-of-contents)
  - [Heckershell](#heckershell)
  - [Doas](#doas)
  - [Flatpak](#flatpak)
  - [Homebrew](#homebrew)
  - [Node Version Manager](#node-version-manager)
  - [Pyenv](#pyenv)
  - [Papirus](#papirus)
  - [TmpMail](#tmpmail)
  - [ZapPm](#zappm)

## Heckershell

A bash/zsh framework for plugins and configurations.

```bash
bash <(wget -qO- https://raw.githubusercontent.com/rmj1001/HeckerShell/main/auto/install.sh)
```

## Doas

A sudo alternative written for BSD, ported to Linux.

```bash
bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/miscellaneous/doas.sh")
```

## Flatpak

Install/repair flatpak, install common repositories, and install common software 
for many categories.

```bash
bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/miscellaneous/flatpak.sh")
```

## Homebrew

A package mamager for installing distro-agnostic developer tools and libraries.

```bash
bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/miscellaneous/homebrew.sh")
```

## Node Version Manager

A package manager for installing different versions of Node.js.

```bash
bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/miscellaneous/nvm.sh")
```

## Pyenv

A package manager for installing different versions of Python.

```bash
bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/miscellaneous/pyenv.sh")
```

## Papirus

A stylish icon set.

```bash
bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/miscellaneous/papirus.sh")
```

## TmpMail

Creates temporary local email addresses

```bash
bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/miscellaneous/tmpmail.sh")
```

## ZapPm

A package manager for AppImages

```bash
bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/miscellaneous/zappm.sh")
```
