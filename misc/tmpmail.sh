#!/usr/bin/env bash

REQUIRECMD "w3m" "jq" "curl" || {
    printf "%b\n" "Aborting 'tmpmail' install."
    exit 1
}

# Download the tmpmail file and make it executable
curl -L "https://git.io/tmpmail" >tmpmail && chmod +x tmpmail

# Then move it somewhere in your $PATH. Here is an example:
sudo mv ./tmpmail /usr/bin

printf "%b\n" "postinstall: 'tmpmail' installed."
