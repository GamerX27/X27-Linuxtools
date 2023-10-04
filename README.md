# My-Linux-Server-Commands-tools


This is tools i have created to help making my selfhosting experience way more easier and less hassle to use
Everything here can be modified if needed its allowed to change it in your own ways


Projects
DebUpgrades
# debupgrade

`debupgrade` is a custom command for Debian-based Linux systems that simplifies the process of updating and upgrading your system with a single command. It also includes an automatic removal of unnecessary packages to help keep your system clean.

## How it Works

1. **Update Package Lists**: `debupgrade` begins by running `sudo apt update` to update the package lists from your software repositories.

2. **Upgrade Installed Packages**: After updating the package lists, it proceeds to upgrade all installed packages with `sudo apt upgrade -y`. The `-y` flag automatically confirms package upgrades without user intervention.

3. **Autoremove Unused Packages**: To keep your system tidy, `debupgrade` concludes by executing `sudo apt autoremove -y`, which removes any unnecessary packages that are no longer required by any installed software.

## Usage

To use `debupgrade`, simply open your terminal and run the following sudo debupgrade which does evrything in one single command




