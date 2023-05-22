#!/usr/bin/env bash

##############################################
#   Author: RMCJ <rmichael1001@gmail.com>
#   Project: Flatpak install helper
#   Version: 1.0
#
#   Usage: flatpak.sh
#
#   Description:
#		Install flatpak repositories and software
##############################################

function CMD_EXISTS() {
	[[ -x "$(command -v "${1}")" ]] && return 0
	return 1
}
function PRINT() { printf "%b\n" "${@}"; }
function NPRINT() { printf "%b" "${@}"; }
function LINES() {
	for ((i = 0; i < COLUMNS; ++i)); do printf -; done
	PRINT
}
# Description: Pauses script execution until the user presses ENTER
# Usage:  PAUSE
# Returns: int
function PAUSE() {
	local pause
	read -r -p "Press <ENTER> to continue..." pause
	return 0
}
function LOWERCASE() {
	printf "%b" "${1}" | tr "[:upper:]" "[:lower:]"
}

# Return 0 if repo exists, 1 if it doesn't exist
# $1 is the repository id
# $2 is the message to print if the repository exists
function checkRepository() {
	local repoInstalled=1

	flatpak remotes --columns=name | while read name; do
		if [[ $name == "$1" ]]; then
			repoInstalled=0
			break
		fi
	done

	return $repoInstalled
}

function checkFlathub() {
	local msg="Flathub exists."
	[[ -n "$1" ]] && msg="$1"

	if [[ $(checkRepository "flathub") -eq 0 ]]; then
		PRINT "${msg}"
		PAUSE
		return 0
	fi

	return 1
}

function checkElementary() {
	local msg="ElementaryOS repository exists."
	[[ -n "$1" ]] && msg="$1"

	if [[ $(checkRepository "elementaryio") -eq 0 ]]; then
		PRINT "${msg}"
		PAUSE
		return 0
	fi

	return 1
}

function FLATINSTALL() {
	flatpak install --user --noninteractive --or-update flathub $@
}

function ctrl_c() {
	PRINT "\nCancelling..."
	PAUSE
	clear
	exit 0
}

trap ctrl_c INT

exited=1

LISTS="https://raw.githubusercontent.com/rmj1001/Post-Installers/main/misc/lists"

# Software lists
allsoft=$(wget -qO- ${LISTS}/0-all-software.txt)
echo "$allsoft"
PAUSE

accessories=$(cat ./lists/accessories.txt)
development=$(cat ./lists/development.txt)
devLibraries=$(cat ./lists/devLibraries.txt)
gaming=$(cat ./lists/gaming.txt)
multimedia=$(cat ./lists/multimedia.txt)
socialmedia=$(cat ./lists/social-media.txt)
utilities=$(cat ./lists/utilities.txt)

while [[ $exited -eq 1 ]]; do
	clear

	printf "%b" "
______ _       _               _    
|  ____| |     | |             | |   
| |__  | | __ _| |_ _ __   __ _| | __
|  __| | |/ _\` | __| '_ \ / _\` | |/ /
| |    | | (_| | |_| |_) | (_| |   < 
|_|    |_|\__,_|\\__| .__/ \\__,_|_|\\_\\
				| |               
				|_|               
"
	LINES
	PRINT
	PRINT "Choose One (type the id number) and press ENTER:"
	PRINT "(Leave empty to cancel)"
	PRINT "-----------------------"
	PRINT "Maintenance"
	PRINT "-----------------------"
	PRINT "m1. Install flatpak"
	PRINT "m2. Repair User"
	PRINT
	PRINT "-----------------------"
	PRINT "Repositories"
	PRINT "-----------------------"
	PRINT "r1. Flathub"
	PRINT "r2. elementaryOS"
	PRINT ""
	PRINT "-----------------------"
	PRINT "Software Categories"
	PRINT "-----------------------"
	PRINT "s0. All Software"
	PRINT "s1. Accessories"
	PRINT "s2. Developer Tools"
	PRINT "s3. Developer Libraries"
	PRINT "s4. Gaming"
	PRINT "s5. Multimedia"
	PRINT "s6. Social Media"
	PRINT "s7. Utilities"
	PRINT
	PRINT "e. Exit"
	PRINT
	read -r -p "ID > " scriptNumber

	case "${scriptNumber}" in

	m1 | 'install flatpak')
		LINES
		CMD_EXISTS "flatpak" || {
			PRINT "Flatpak is not installed."

			CMD_EXISTS "apt" && {
				sudo apt install flatpak gnome-software-plugin-flatpak
			} ||
				CMD_EXISTS "dnf" && {
				sudo dnf install flatpak
			} || {
				PRINT "Unsupported distro. Please use Ubuntu or Debian. Aborting..."
				exit 1
			}

			PRINT "Installed Flatpak."

			PAUSE
			continue
		}

		PRINT "Flatpak is installed."
		PAUSE
		;;

	m2 | 'repair user')
		LINES
		flatpak repair --user
		PAUSE
		continue
		;;

	r1 | flathub)
		LINES

		checkFlathub && continue

		flatpak remote-add --if-not-exists --user \
			flathub https://flathub.org/repo/flathub.flatpakrepo
		PAUSE
		continue
		;;

	r2 | elementaryos)
		LINES

		checkElementary && continue

		flatpak remote-add --if-not-exists --user \
			flatpak remote-add --if-not-exists --user \
			elementaryio https://flatpak.elementary.io/repo.flatpakrepo
		PAUSE
		continue
		;;
	s0 | 'all software')
		LINES
		checkFlathub || {
			PRINT "Flathub isn't installed. Cancelling..."
			continue
		}

		FLATINSTALL ${allsoft[@]}

		PAUSE
		continue
		;;
	s1 | accessories)
		LINES
		checkFlathub || {
			PRINT "Flathub isn't installed. Cancelling..."
			continue
		}

		FLATINSTALL ${accessories[@]}

		PAUSE
		continue
		;;
	s2 | 'developer tools')
		LINES
		checkFlathub || {
			PRINT "Flathub isn't installed. Cancelling..."
			continue
		}

		FLATINSTALL ${development[@]}

		PAUSE
		continue
		;;
	s3 | 'developer libraries')
		LINES
		checkFlathub || {
			PRINT "Flathub isn't installed. Cancelling..."
			continue
		}

		FLATINSTALL ${devLibraries[@]}

		PAUSE
		continue
		;;
	s4 | gaming)
		LINES
		checkFlathub || {
			PRINT "Flathub isn't installed. Cancelling..."
			continue
		}

		FLATINSTALL ${gaming[@]}

		PAUSE
		continue
		;;
	s5 | multimedia)
		LINES
		checkFlathub || {
			PRINT "Flathub isn't installed. Cancelling..."
			continue
		}

		FLATINSTALL ${multimedia[@]}

		PAUSE
		continue
		;;
	s6 | 'social media')
		LINES
		checkFlathub || {
			PRINT "Flathub isn't installed. Cancelling..."
			continue
		}

		FLATINSTALL ${socialmedia[@]}

		PAUSE
		continue
		;;
	s7 | utilities)
		LINES
		checkFlathub || {
			PRINT "Flathub isn't installed. Cancelling..."
			continue
		}

		FLATINSTALL ${utilities[@]}

		PAUSE
		continue
		;;
	e | exit)
		PRINT "\nExiting..."
		PAUSE
		clear
		exit 0
		;;
	*)
		LINES
		PRINT
		[[ -z "${scriptNumber}" ]] && PRINT "Canceling."
		[[ -n "${scriptNumber}" ]] && PRINT "Invalid option '${scriptNumber}'. Aborting."
		PRINT
		PAUSE
		continue
		;;
	esac
done
