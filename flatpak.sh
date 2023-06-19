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

################################################################################
#                                 API/Functions                                #
################################################################################

function CMD_EXISTS()
{
	[[ -x "$(command -v "${1}")" ]] && return 0
	return 1
}

function PRINT()
{
  printf "%b\n" "${@}"
}

function NPRINT()
{
  printf "%b" "${@}"
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
	local pause
	read -r -p "Press <ENTER> to continue..." pause
	return 0
}

function LOWERCASE()
{
	printf "%b" "${1}" | tr "[:upper:]" "[:lower:]"
}

# Return 0 if repo exists, 1 if it doesn't exist
# $1 is the repository id
# $2 is the message to print if the repository exists
function checkRepository()
{
	local repoInstalled=1

	flatpak remotes --columns=name | while read name; do
		if [[ $name == "$1" ]]; then
			repoInstalled=0
			break
		fi
	done

	return $repoInstalled
}

function checkFlathub()
{
	local msg="Flathub exists."
	[[ -n "$1" ]] && msg="$1"

	if [[ $(checkRepository "flathub") -eq 0 ]]; then
		PRINT "${msg}"
		PAUSE
		return 0
	fi

	return 1
}

function checkElementary()
{
	local msg="ElementaryOS repository exists."
	[[ -n "$1" ]] && msg="$1"

	if [[ $(checkRepository "elementaryio") -eq 0 ]]; then
		PRINT "${msg}"
		PAUSE
		return 0
	fi

	return 1
}

function FLATINSTALL()
{
	flatpak install --noninteractive --or-update flathub "$@"
}

function ctrl_c()
{
	PRINT "\nCancelling..."
	PAUSE
	clear
	exit 0
}

trap ctrl_c INT

exited=1

################################################################################
#                                Software lists                                #
################################################################################
accessories=(
com.belmoussaoui.Authenticator 
com.belmoussaoui.Obfuscate 
com.bitwarden.desktop 
com.github.calo001.fondo 
com.github.hugolabe.Wike 
com.github.maoschanz.drawing 
com.github.rafostar.Clapper 
com.gitlab.newsflash 
com.rafaelmardojai.Blanket 
de.haeckerfelix.Shortwave 
fr.free.Homebank 
im.bernard.Nostalgia 
io.github.lainsce.Quilter 
io.github.prateekmedia.appimagepool 
io.github.seadve.Kooha 
io.github.shiftey.Desktop 
it.mijorus.smile 
org.gabmus.giara 
org.gnome.Aisleriot 
org.gnome.Calculator 
org.gnome.Calls 
org.gnome.Evince 
org.gnome.Fractal 
org.gnome.Lollypop 
org.gnome.Maps 
org.gnome.Podcasts 
org.gnome.Polari 
org.gnome.World.PikaBackup 
org.gnome.World.Secrets 
org.gnome.eog 
org.gnome.gitlab.Cowsay 
org.gnome.gitlab.somas.Apostrophe 
org.gnome.gitlab.somas.Apostrophe.Plugin.TexLive 
org.gnome.seahorse.Application 
org.gnucash.GnuCash 
org.gustavoperedo.FontDownloader 
org.libreoffice.LibreOffice 
org.mozilla.firefox 
org.onlyoffice.desktopeditors 
org.turbowarp.TurboWarp 
org.videolan.VLC 
org.x.Warpinator 
re.sonny.Junction 
re.sonny.Tangram
)

development=(
ar.xjuan.Cambalache
com.axosoft.GitKraken
com.vscodium.codium
dev.geopjr.Collision
org.gnome.Builder
re.sonny.Commit
)

developerLibraries=(
org.freedesktop.Sdk 
org.freedesktop.Sdk.Extension.dotnet 
org.freedesktop.Sdk.Extension.golang 
org.freedesktop.Sdk.Extension.haskell 
org.freedesktop.Sdk.Extension.mono6 
org.freedesktop.Sdk.Extension.node16 
org.freedesktop.Sdk.Extension.openjdk 
org.freedesktop.Sdk.Extension.php74 
org.freedesktop.Sdk.Extension.rust-stable
)

gaming=(
com.etlegacy.ETLegacy
com.thebrokenrail.MCPIReborn
io.github.achetagames.epic_asset_manager
net.veloren.veloren
org.gnome.Chess
org.gnome.Mines
org.xonotic.Xonotic
)

multimedia=(
com.github.wwmm.easyeffects
com.obsproject.Studio
com.obsproject.Studio.Plugin.Gstreamer
com.obsproject.Studio.Plugin.InputOverlay
com.obsproject.Studio.Plugin.OBSVkCapture
de.haeckerfelix.AudioSharing
de.haeckerfelix.Fragments
io.github.Soundux
nl.hjdskes.gcolor3
org.audacityteam.Audacity
org.gimp.GIMP
org.gimp.GIMP.Manual
org.gimp.GIMP.Plugin.Resynthesizer
org.gnome.design.IconLibrary
org.gnome.gitlab.YaLTeR.VideoTrimmer
org.inkscape.Inkscape
org.kde.kdenlive
org.kde.krita
)

socialMedia=(
com.discordapp.Discord
com.github.bleakgrey.tootle
com.skype.Client
network.loki.Session
org.signal.Signal
us.zoom.Zoom
)

utilities=(
ca.desrt.dconf-editor
com.github.tchx84.Flatseal
com.mattjakeman.ExtensionManager
com.usebottles.bottles
fr.romainvigier.MetadataCleaner
org.gnome.Boxes
org.gnome.Boxes.Extension.OsinfoDb
org.gnome.Connections
org.gnome.DejaDup
org.winehq.Wine.DLLs.dxvk
org.winehq.Wine.gecko
org.winehq.Wine.mono
)

allSoftware=(
  "${accessories[@]}" "${development[@]}" "${developerLibraries[@]}" 
  "${gaming[@]}" "${multimedia[@]}" "${socialMedia[@]}" "${utilities[@]}"
)

################################################################################
#                                  Menu & Logic                                #
################################################################################

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
	read -r -p "ID > " option

	case "${option}" in

	m1 | 'install flatpak')
		LINES
		CMD_EXISTS "flatpak" && {
		  PRINT "Flatpak already exists."
		  PAUSE
			continue
		}
		
		CMD_EXISTS "apt" && {
			sudo apt install flatpak gnome-software-plugin-flatpak
		  PRINT "Installed Flatpak."
		  PAUSE
			continue
			}
			
		CMD_EXISTS "dnf" && {
			sudo dnf install flatpak
		  PRINT "Installed Flatpak."
		  PAUSE
			continue
			}
			
			PRINT "Unsupported distro. Please use Ubuntu or Debian. Aborting..."
			exit 1
		;;

	m2 | 'repair user')
		LINES
		flatpak repair
		PAUSE
		continue
		;;

	r1 | flathub)
		LINES

		checkFlathub && continue

		flatpak remote-add --if-not-exists  \
			flathub https://flathub.org/repo/flathub.flatpakrepo

		PAUSE
		continue
		;;

	r2 | elementaryos)
		LINES

		checkElementary && continue

		flatpak remote-add --if-not-exists  \
			flatpak remote-add --if-not-exists  \
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

		FLATINSTALL "${allSoftware[@]}"

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

		FLATINSTALL ${developerLibraries[@]}

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

		FLATINSTALL ${socialMedia[@]}

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
		[[ -z "${option}" ]] && PRINT "Canceling."
		[[ -n "${option}" ]] && \
		  PRINT "Invalid option '${option}'. Aborting."
		PRINT
		PAUSE
		continue
		;;
	esac
done
