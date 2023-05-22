#!/usr/bin/env bash

export NVM_DIR="$HOME/.nvm" && (
    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
) && \. "$NVM_DIR/nvm.sh"

read -r -p "Add nvm source to your shellrc? y/N" addSrc
[[ -z "${addsrc}" || ! "${addsrc}" =~ [yY][eE]?[sS]? ]] && exit 0

SHELLRC="${HOME}/.${SHELL//\/bin\//}rc"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

PRINT "export NVM_DIR=\"\$HOME/.nvm\"" >>${SHELLRC}
PRINT "[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"" >>${SHELLRC}
PRINT "[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\"" >>${SHELLRC}
