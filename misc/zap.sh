#!/usr/bin/env bash

# Zap Appimage PM (requires jq)
wget -qO- https://raw.githubusercontent.com/srevinsaju/zap/main/install.sh |
    bash -s

zap init
zap daemon --install
