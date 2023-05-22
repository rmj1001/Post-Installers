<!--
##############################################
#   Author(s): RMCJ <rmichael1001@gmail.com>
#   Project: HeckerShell
#   Version: 1.0
#
#   Usage: n/a
#
#   Description: Distro post-install info
#
##############################################
-->
# Post-installation Scripts

The scripts in this directory install common software, repositories, and apply
common configurations for various Linux operating systems.

## Post-install master script

```bash
bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/postinstall")
```

## Individual Distribution Post-install Scripts

To install the software you want, copy the code and paste it into your terminal.

| Script Name | Code                                                                                                       |
| ----------- | ---------------------------------------------------------------------------------------------------------- |
| Fedora      | ```bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/distros/fedora.sh")``` |
| Ubuntu      | ```bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/distros/ubuntu.sh")``` |

## Individual Miscellaneous Scripts

To install the software you want, copy the code and paste it into your terminal.

| Script Name | Code                                                                                                      |
| ----------- | --------------------------------------------------------------------------------------------------------- |
| Doas        | ```bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/misc/doas.sh")```     |
| Flatpak     | ```bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/misc/flatpak.sh")```  |
| Homebrew    | ```bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/misc/homebrew.sh")``` |
| NVM         | ```bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/misc/nvm.sh")```      |
| Papirus     | ```bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/misc/papirus.sh")```  |
| Pyenv       | ```bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/misc/pyenv.sh")```    |
| TmpMail     | ```bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/misc/tmpmail.sh")```  |
| ZapPm       | ```bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/misc/zappm.sh")```    |
