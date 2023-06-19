#!/usr/bin/env bash

##############################################
#   Author: RMCJ <rmichael1001@gmail.com>
#   Project: com.github.rmj1001.Post-Installers
#   Version: 1.0
#
#   Usage: distromgr.sh
#
#   Description:
#		Curlable Postinstallation Script
##############################################

function PRINT() { printf "%b\n" "${@}"; }
function LINES() {
    for ((i = 0; i < COLUMNS; ++i)); do printf -; done
    PRINT
}
# Description: Pauses script execution until the user presses ENTER
# Usage:  PAUSE
# Returns: int
function PAUSE() {
    printf "%b" "Press <ENTER> to continue..."
    read -r
}
function LOWERCASE() {
    printf "%b" "${1}" | tr "[:upper:]" "[:lower:]"
}
function FINDCMD() {
    [[ -x "$(command -v ${1})" ]] && return 0
    return 1
}

function REQUIRECMD() {
    local metRequirements=0

    for cmd in "${@}"; do
        FINDCMD "${cmd}" && continue
        PRINT "Missing Dependency: ${cmd}"
        metRequirements=1
    done

    [[ $metRequirements -eq 0 ]] && return 0
    return 1
}

function ctrl_c() {
    PRINT "\n"
    [[ -z "${option}" ]] && PRINT "Canceling.\n"
    clear
    exit 0
}

DISTRO="NONE"

FEDORA() {
    [[ "${DISTRO}" == "FEDORA" ]] && return 0
    return 1
}

UBUNTU() {
    [[ "${DISTRO}" == "UBUNTU" ]] && return 0
    return 1
}

trap ctrl_c INT

function choose_distro() {
    clear
    PRINT "    ___ _     _                                                              "
    PRINT "   /   (_)___| |_ _ __ ___     /\/\   __ _  __ _ _ __   __ _  __ _  ___ _ __ "
    PRINT "  / /\ / / __| __| '__/ _ \   /    \ / _\` |/ _\` | '_ \ / _\` |/ _\` |/ _ \ '__|"
    PRINT " / /_//| \__ \ |_| | | (_) | / /\/\ \ (_| | (_| | | | | (_| | (_| |  __/ |   "
    PRINT "/___,' |_|___/\__|_|  \___/  \/    \/\__,_|\__,_|_| |_|\__,_|\__, |\___|_|   "
    PRINT "                                                             |___/           "
    LINES
    PRINT
    PRINT "Choose a Distro and press ENTER:"
    PRINT "(Leave empty to cancel)"
    PRINT
    PRINT "-----------------------"
    PRINT "Distros"
    PRINT "-----------------------"
    PRINT "Fedora"
    PRINT "Ubuntu"
    PRINT
    read -r -p "ID > " option

    case "$(LOWERCASE ${option})" in

    d1 | fedora)
        DISTRO="FEDORA"
        manage_distro
        ;;

    d2 | ubuntu)
        DISTRO="UBUNTU"
        manage_distro
        ;;

    *)
        PRINT
        [[ -z "${option}" ]] && PRINT "Canceling."
        [[ -n "${option}" ]] && PRINT "Invalid option '${option}'. Aborting."
        PRINT
        exit 0
        ;;
    esac
}

function manage_distro() {
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
        PRINT "0. Switch Distro (Current Distro: \"${DISTRO}\")"
        PRINT "1. Fix DNF (fedora only)"
        PRINT "2. Install Repositories (RECOMMENDED)"
        PRINT "3. Enable Cronie"
        PRINT "4. Update System"
        PRINT ""
        PRINT "-----------------------"
        PRINT " Install software"
        PRINT "-----------------------"
        PRINT
        PRINT "5. Developer Tools"
        PRINT "6. Multimedia"
        PRINT "7. Gaming"
        PRINT "8. Ubuntu Snaps"
        PRINT "9. Microsoft Edge"
        PRINT "10. VS Code"
        PRINT "11. Miscellaneous"
        PRINT
        PRINT "99. Exit"
        PRINT
        LINES
        PRINT "Type in the ID of the action, then press ENTER."
        read -r -p "ID > " option
        LINES

        case "$(LOWERCASE ${option})" in

        0 | 'switch distro')
            choose_distro
            ;;
            
        1 | 'fix dnf')
            FEDORA && {
              clear
                
              # Configure DNF
              printf '%b\n' "[main]" | sudo tee /etc/dnf/dnf.conf
              printf '%b\n' "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
              printf '%b\n' "max_parallel_downloads=20" | sudo tee -a /etc/dnf/dnf.conf
              printf '%b\n' "deltarpm=False" | sudo tee -a /etc/dnf/dnf.conf
              printf '%b\n' "defaultyes=True" | sudo tee -a /etc/dnf/dnf.conf
            }
            
            PAUSE
            continue
            ;;

        2 | 'install repositories')
            FEDORA && {
                clear

                # RPM Fusion
                sudo dnf install \
                    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
                    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

                sudo dnf groupupdate core
            }

            UBUNTU && {
                # Install repositories/ppas
                ppas=(
                    "ppa:lutris-team/lutris"
                    "multiverse"
                )

                for ppa in "${ppas[@]}"; do

                    sudo add-apt-repository -y -n "${ppa}"

                done

                sudo apt update
            }

            PAUSE
            continue
            ;;

        3 | 'enable cronie')
            FEDORA && {
                sudo dnf install cronie
            }

            UBUNTU && {
                sudo apt install cronie
            }

            systemctl enable crond

            PAUSE
            continue
            ;;
        4 | update | 'update system')
            FEDORA && {
                sudo dnf update
            }

            UBUNTU && {
                sudo apt update && sudo apt upgrade
            }

            PAUSE
            continue
            ;;

        5 | 'developer tools')
            FEDORA && {
                sudo dnf update
                sudo dnf groupinstall "Development Tools" "Development Libraries"
            }

            UBUNTU && {
                sudo apt install \
                    build-essential \
                    meson \
                    libsystemd-dev \
                    pkg-config \
                    ninja-build \
                    git \
                    libdbus-1-dev \
                    libinih-dev
            }

            PAUSE
            continue
            ;;
          
        6 | 'multimedia')
            FEDORA && {
                sudo dnf groupupdate multimedia --setop="install_weak_deps=False" \
                    --exclude=PackageKit-gstreamer-plugin

                sudo dnf groupupdate sound-and-video
                sudo dnf install rpmfusion-free-release-tainted
                sudo dnf install libdvdcss
            }

            UBUNTU && {
                sudo apt install ubuntu-restricted-extras
            }

            PAUSE
            continue
            ;;

        7 | gaming)
            FEDORA && {
                sudo dnf install lutris
            }
            UBUNTU && {
                sudo apt install lutris
            }

            PAUSE
            continue
            ;;
        8 | 'ubuntu snaps')
            [[ -e /var/lib/snapd/snap ]] && {
                PRINT "Snap is already installed."

                PAUSE
                continue
            }

            FEDORA && {
                sudo dnf install snapd fuse squashfuse kernel-modules
                sudo ln -s /var/lib/snapd/snap /snap
            }

            UBUNTU && {
                PRINT "Snap is already installed on Ubuntu."
            }

            PAUSE
            continue
            ;;
        9 | 'microsoft edge')
            FEDORA && {
                sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
                dnf install microsoft-edge
            }

            UBUNTU && {
                curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
                sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
                sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
                sudo rm microsoft.gpg
                sudo apt update && sudo apt install microsoft-edge-stable
            }

            PAUSE
            continue
            ;;
        10 | 'vs code')
            [[ -n "$(command -v code)" ]] && {
                PRINT "VS Code is already installed"

                PAUSE
                continue
            }

            FEDORA && {
              # VS Code
              sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
              sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
              dnf check-update
              sudo dnf install code
            }

            UBUNTU && {
              sudo apt-get install wget gpg
              wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
              sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
              sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
              rm -f packages.microsoft.gpg
              sudo apt install apt-transport-https
              sudo apt update
              sudo apt install code
            }

            PAUSE
            continue
            ;;

        11 | miscellaneous)
          # TODO: Use arrays and loops to allow users to choose which software
          # to install
            FEDORA && {
              sudo dnf install xclip micro jq
            }

            UBUNTU && {
              PRINT "There is no miscellaneous software to install for Ubuntu."
            }

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

choose_distro
