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

# Description: 'echo' replacement w/o newline
# Usage:  NPRINT "text"
# Returns: string
function NPRINT() {
	printf "%b" "${@}"
}

# Description: Check to see if input is 'yes' or empty
# Usage:  CHECK_YES <var>
# Returns: return code (0 for yes/empty, 1 for no)
function CHECK_YES() {
	[[ "$1" =~ [yY][eE]?[sS]? ]] && return 0
	[[ -z "$1" ]] && return 0

	return 1
}

# Description: Prompt with message, check if input is 'yes' or empty
# Usage:  PROMPT_YES "prompt text"
# Returns: return code (0 for yes/empty, 1 for no)
function PROMPT_YES() {
	local confirm

	NPRINT "${1}? (Y/n) "
	read -r confirm

	CHECK_YES "${confirm}"
}

CMD_EXISTS "flatpak" || {
	printf "%b\n" "Flatpak is not installed."

	CMD_EXISTS "apt" && {
		sudo apt install flatpak gnome-software-plugin-flatpak
	} ||
		CMD_EXISTS "dnf" && {
		sudo dnf install flatpak
	} || {
		printf "%b\n" "Unsupported distro. Please use Ubuntu or Debian. Aborting..."
		exit 1
	}

	printf "%b\n" "Installed Flatpak."
}

flathubInstalled=1

# Request to install flathub
if [[ $(PROMPT_YES "Install Flathub?") -eq 0 ]]; then
	flatpak remote-add --if-not-exists --user \
		flathub https://flathub.org/repo/flathub.flatpakrepo &&
		flathubInstalled=0
else
	NPRINT "Skipping installation of flathub.\n"
fi

# Request to install ElementaryOS repo
if [[ $(PROMPT_YES "Install elementaryOS flatpak repository?") -eq 0 ]]; then
	flatpak remote-add --if-not-exists --user \
		flatpak remote-add --if-not-exists --user \
		elementaryio https://flatpak.elementary.io/repo.flatpakrepo
else
	NPRINT "Skipping installation of elementaryOS repository.\n"
fi

# Request to install ElementaryOS repo
if [[ $(PROMPT_YES "Repair user flatpak files? (optional)") -eq 0 ]]; then
	flatpak repair --user
else
	NPRINT "Skipping flatpak repairs.\n"
fi

# Skip installing software if flathub isn't installed
if [[ $flathubInstalled -eq 1 ]]; then
	NPRINT "Skipping installation of flatpaks since flathub isn't installed.\n"
	exit 0
fi

# Request to install software
if [[ $(PROMPT_YES "Install software from flathub?") -eq 0 ]]; then
	flatpak install --user --noninteractive --or-update flathub \
		ar.xjuan.Cambalache \
		ca.desrt.dconf-editor \
		com.axosoft.GitKraken \
		com.belmoussaoui.Authenticator \
		com.belmoussaoui.Obfuscate \
		com.bitstower.Markets \
		com.bitwarden.desktop \
		com.discordapp.Discord \
		com.etlegacy.ETLegacy \
		com.github.bleakgrey.tootle \
		com.github.calo001.fondo \
		com.github.gi_lom.dialect \
		com.github.hugolabe.Wike \
		com.github.maoschanz.drawing \
		com.github.rafostar.Clapper \
		com.github.tchx84.Flatseal \
		com.github.wwmm.easyeffects \
		com.gitlab.newsflash \
		com.mattjakeman.ExtensionManager \
		com.obsproject.Studio \
		com.obsproject.Studio.Plugin.Gstreamer \
		com.obsproject.Studio.Plugin.InputOverlay \
		com.obsproject.Studio.Plugin.OBSVkCapture \
		com.rafaelmardojai.Blanket \
		com.skype.Client \
		com.thebrokenrail.MCPIReborn \
		com.usebottles.bottles \
		com.vscodium.codium \
		de.haeckerfelix.AudioSharing \
		de.haeckerfelix.Fragments \
		de.haeckerfelix.Shortwave \
		dev.geopjr.Collision \
		fr.free.Homebank \
		fr.romainvigier.MetadataCleaner \
		im.bernard.Nostalgia \
		io.github.Soundux \
		io.github.achetagames.epic_asset_manager \
		io.github.lainsce.Quilter \
		io.github.prateekmedia.appimagepool \
		io.github.seadve.Kooha \
		io.github.shiftey.Desktop \
		it.mijorus.smile \
		net.veloren.veloren \
		network.loki.Session \
		nl.hjdskes.gcolor3 \
		org.audacityteam.Audacity \
		org.gabmus.giara \
		org.gimp.GIMP \
		org.gimp.GIMP.Manual \
		org.gimp.GIMP.Plugin.Resynthesizer \
		org.gnome.Aisleriot \
		org.gnome.Boxes \
		org.gnome.Boxes.Extension.OsinfoDb \
		org.gnome.Builder \
		org.gnome.Calculator \
		org.gnome.Calls \
		org.gnome.Chess \
		org.gnome.Connections \
		org.gnome.DejaDup \
		org.gnome.Evince \
		org.gnome.Extensions \
		org.gnome.Extensions \
		org.gnome.Fractal \
		org.gnome.Lollypop \
		org.gnome.Maps \
		org.gnome.Mines \
		org.gnome.PasswordSafe \
		org.gnome.Podcasts \
		org.gnome.Polari \
		org.gnome.World.PikaBackup \
		org.gnome.World.Secrets \
		org.gnome.design.IconLibrary \
		org.gnome.eog \
		org.gnome.gitlab.Cowsay \
		org.gnome.gitlab.YaLTeR.VideoTrimmer \
		org.gnome.gitlab.somas.Apostrophe \
		org.gnome.gitlab.somas.Apostrophe.Plugin.TexLive \
		org.gnome.seahorse.Application \
		org.gnucash.GnuCash \
		org.gustavoperedo.FontDownloader \
		org.inkscape.Inkscape \
		org.kde.kdenlive \
		org.kde.krita \
		org.libreoffice.LibreOffice \
		org.mozilla.firefox \
		org.onlyoffice.desktopeditors \
		org.signal.Signal \
		org.turbowarp.TurboWarp \
		org.videolan.VLC \
		org.winehq.Wine.DLLs.dxvk \
		org.winehq.Wine.gecko \
		org.winehq.Wine.mono \
		org.x.Warpinator \
		org.xonotic.Xonotic \
		re.sonny.Commit \
		re.sonny.Junction \
		re.sonny.Tangram \
		uk.co.ibboard.cawbird \
		us.zoom.Zoom

	# Install developer libraries if user requests them
	if [[ $(PROMPT_YES "Do you want to install developer libraries?") -eq 0 ]]; then

		flatpak install --user --non-interactive --or-update flathub \
			org.freedesktop.Sdk \
			org.freedesktop.Sdk.Extension.dotnet \
			org.freedesktop.Sdk.Extension.golang \
			org.freedesktop.Sdk.Extension.haskell \
			org.freedesktop.Sdk.Extension.mono6 \
			org.freedesktop.Sdk.Extension.node16 \
			org.freedesktop.Sdk.Extension.openjdk \
			org.freedesktop.Sdk.Extension.php74 \
			org.freedesktop.Sdk.Extension.rust-stable
	else
		NPRINT "Skipping installation of developer libraries.\n"
		exit 0
	fi

else
	NPRINT "Skipping flatpak installations.\n"
	exit 0
fi
