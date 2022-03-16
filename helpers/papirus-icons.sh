#!/usr/bin/env bash

# Papirus Icons
wget -qO- https://git.io/papirus-icon-theme-install | sh
wget -qO- https://git.io/papirus-folders-install | sh

papirus-folders --theme Papirus-Dark -C yaru
papirus-folders --theme Papirus-Light -C yaru
gsettings set org.gnome.desktop.interface icon-theme Papirus-Light
