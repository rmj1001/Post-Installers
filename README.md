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
common configurations for various OSs.

Return [Home](../../README.md)

## Post-install master script

```bash
bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/postinstall")
```

## Individual Distribution Post-install Scripts

To install the software you want, copy the code for the related category.

| Script Name | Code                                                                                                   |
| ----------- | ------------------------------------------------------------------------------------------------------ |
| Fedora      | `bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/distros/fedora.sh")` |
| Ubuntu      | `bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/distros/ubuntu.sh")` |

## Individual Miscellaneous Scripts

| Script Name | Code                                                                                                 |
| ----------- | ---------------------------------------------------------------------------------------------------- |
| Flatpak     | `bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/misc/flatpak.sh")` |
| PyEnv       | `bash <(wget -qO- "https://raw.githubusercontent.com/rmj1001/Post-Installers/main/misc/pyenv.sh")`   |
