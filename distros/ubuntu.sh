#!/usr/bin/env bash

##############################################
#   Author: RMCJ <rmichael1001@gmail.com>
#   Project: com.github.rmj1001.Post-Installers
#   Version: 1.0
#
#   Usage: ubuntu.sh
#
#   Description:
#		Curlable Postinstallation Script for Ubuntu
##############################################

function PRINT()
{
  printf "%b\n" "${@}"
}

function LINES()
{
    for ((i = 0; i < COLUMNS; ++i)); do printf -; done
    PRINT
}

# Description: Pauses script execution until the user presses ENTER
# Usage:  PAUSE
# Returns: int
function PAUSE()
{
    printf "%b" "Press <ENTER> to continue..."
    read -r
}

function LOWERCASE()
{
    printf "%b" "${1}" | tr "[:upper:]" "[:lower:]"
}

function FINDCMD()
{
    [[ -x "$(command -v ${1})" ]] && return 0
    return 1
}

function REQUIRECMD()
{
    local metRequirements=0

    for cmd in "${@}"; do
        FINDCMD "${cmd}" && continue
        PRINT "Missing Dependency: ${cmd}"
        metRequirements=1
    done

    [[ $metRequirements -eq 0 ]] && return 0
    return 1
}

function ctrl_c()
{
    PRINT "\n"
    [[ -z "${option}" ]] && PRINT "Canceling.\n"
    clear
    exit 0
}

trap ctrl_c INT

miscSoftware=()

softwareToInstall=()

function manage_distro()
{
    while EXIT=1; do
        clear
        PRINT "    ___ _     _                                                              "
        PRINT "   /   (_)___| |_ _ __ ___     /\/\   __ _  __ _ _ __   __ _  __ _  ___ _ __ "
        PRINT "  / /\ / / __| __| '__/ _ \   /    \ / _\` |/ _\` | '_ \ / _\` |/ _\` |/ _ \ '__|"
        PRINT " / /_//| \__ \ |_| | | (_) | / /\/\ \ (_| | (_| | | | | (_| | (_| |  __/ |   "
        PRINT "/___,' |_|___/\__|_|  \___/  \/    \/\__,_|\__,_|_| |_|\__,_|\__, |\___|_|   "
        PRINT "                                                             |___/           "
        LINES
        PRINT
        PRINT "-----------------------"
        PRINT "Maintenance"
        PRINT "-----------------------"
        PRINT
        PRINT "1. Install Repositories (RECOMMENDED)"
        PRINT "2. Enable Cronie"
        PRINT "3. Update System"
        PRINT ""
        PRINT "-----------------------"
        PRINT " Install software"
        PRINT "-----------------------"
        PRINT
        PRINT "4. Developer Tools"
        PRINT "5. Multimedia"
        PRINT "6. Gaming"
        PRINT "7. Microsoft Edge"
        PRINT "8. VS Code"
        PRINT "9. Miscellaneous"
        PRINT
        PRINT "99. Exit"
        PRINT
        LINES
        PRINT "Type in the ID of the action, then press ENTER."
        read -r -p "ID > " option
        LINES

        case "$(LOWERCASE ${option})" in

        1 | 'install respositories')
            # Install repositories/ppas
            ppas=(
                "ppa:lutris-team/lutris"
                "multiverse"
            )

            for ppa in "${ppas[@]}"; do

                sudo add-apt-repository -y -n "${ppa}"

            done

            sudo apt update

            PAUSE
            continue
            ;;

        2 | 'enable cronie')
            sudo apt install cronie

            systemctl enable crond

            PAUSE
            continue
            ;;

        3 | update | 'update system')
            sudo apt update && sudo apt upgrade

            PAUSE
            continue
            ;;

        4 | 'developer tools')
            sudo apt install \
              build-essential \
              meson \
              libsystemd-dev \
              pkg-config \
              ninja-build \
              git \
              libdbus-1-dev \
              libinih-dev

            PAUSE
            continue
            ;;

        5 | 'multimedia')
            sudo apt install ubuntu-restricted-extras

            PAUSE
            continue
            ;;

        6 | gaming)
            sudo apt install lutris

            PAUSE
            continue
            ;;

        7 | 'microsoft edge')
            curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
            sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
            sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
            sudo rm microsoft.gpg
            sudo apt update && sudo apt install microsoft-edge-stable

            PAUSE
            continue
            ;;

        8 | 'vs code')
            [[ -n "$(command -v code)" ]] && {
                PRINT "VS Code is already installed"

                PAUSE
                continue
            }

            sudo apt-get install wget gpg
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
            sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
            sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
            rm -f packages.microsoft.gpg
            sudo apt install apt-transport-https
            sudo apt update
            sudo apt install code

            PAUSE
            continue
            ;;

        9 | miscellaneous)
            [[ ${miscSoftware[#]} -eq 0 ]] && \
            {
              PRINT "There is no miscellaneous software to install."
              PAUSE
              continue
            }

            for pkg in "${miscSoftware[@]}"; do
              read -p "Install '${pkg}'? (y/N) " choice
              [[ "${choice}" =~ \w*[yY][eE]?[sS]?\w* ]] && \
              {
                softwareToInstall+=("${pkg}")
              }
            done

            sudo apt install "${softwareToInstall[@]}"

            PAUSE
            continue
            ;;

        99 | exit)
            clear
            exit 0
            ;;
        *)
            PRINT
            [[ -z "${option}" ]] && PRINT "You must choose an option."
            [[ -n "${option}" ]] && PRINT "Invalid option '${option}'."
            PRINT

            PAUSE
            continue
            ;;
        esac

    done
}

manage_distro

