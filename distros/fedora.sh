#!/usr/bin/env bash

##############################################
#   Author: RMCJ <rmichael1001@gmail.com>
#   Project: com.github.rmj1001.Post-Installers
#   Version: 1.0
#
#   Usage: fedora.sh
#
#   Description:
#		Curlable Postinstallation Script for Fedora
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

miscSoftware=(
  "xclip"
  "micro"
  "jq"
)

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
    PRINT "1. Fix DNF"
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

    1 | 'fix dnf')
      clear

      # Configure DNF
      printf '%b\n' "[main]" | sudo tee /etc/dnf/dnf.conf
      printf '%b\n' "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
      printf '%b\n' "max_parallel_downloads=20" | sudo tee -a /etc/dnf/dnf.conf
      printf '%b\n' "deltarpm=False" | sudo tee -a /etc/dnf/dnf.conf
      printf '%b\n' "defaultyes=True" | sudo tee -a /etc/dnf/dnf.conf

      PAUSE
      continue
      ;;

    2 | 'install repositories')
      clear

      # RPM Fusion
      sudo dnf install \
          "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
          "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

      sudo dnf groupupdate core

      PAUSE
      continue
      ;;

    3 | 'enable cronie')
      sudo dnf install cronie

      systemctl enable crond

      PAUSE
      continue
      ;;

    4 | update | 'update system')
      sudo dnf update

      PAUSE
      continue
      ;;

    5 | 'developer tools')
      sudo dnf update
      sudo dnf groupinstall "Development Tools" "Development Libraries"

      PAUSE
      continue
      ;;

    6 | 'multimedia')
      sudo dnf groupupdate multimedia --setop="install_weak_deps=False" \
          --exclude=PackageKit-gstreamer-plugin

      sudo dnf groupupdate sound-and-video
      sudo dnf install rpmfusion-free-release-tainted
      sudo dnf install libdvdcss

      PAUSE
      continue
      ;;

    7 | gaming)
      sudo dnf install lutris

      PAUSE
      continue
      ;;

    8 | 'ubuntu snaps')
      [[ -e /var/lib/snapd/snap ]] && {
          PRINT "Snap is already installed."

          PAUSE
          continue
      }

      sudo dnf install snapd fuse squashfuse kernel-modules
      sudo ln -s /var/lib/snapd/snap /snap

      PAUSE
      continue
      ;;

    9 | 'microsoft edge')
      sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
      sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
      dnf install microsoft-edge

      PAUSE
      continue
      ;;

    10 | 'vs code')
      [[ -n "$(command -v code)" ]] && {
          PRINT "VS Code is already installed"

          PAUSE
          continue
      }

      # VS Code
      sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
      sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
      dnf check-update
      sudo dnf install code

      PAUSE
      continue
      ;;

    11 | miscellaneous)
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

      sudo dnf install "${softwareToInstall[@]}"

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

