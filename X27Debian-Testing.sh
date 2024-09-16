#!/bin/bash

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Install Cinnamon desktop environment
echo "Installing Cinnamon desktop environment..."
sudo apt install -y cinnamon-core || { echo "Failed to install Cinnamon desktop environment!"; exit 1; }

# Install necessary packages
echo "Installing necessary packages..."
sudo apt install -y git libcurl4 curl htop flatpak eom papirus-icon-theme synaptic distrobox pysassc build-essential xdg-user-dirs xdg-user-dirs-gtk plasma-discover plasma-discover-backend-flatpak || { echo "Failed to install necessary packages!"; exit 1; }

# Install SDDM (KDE Login Manager) and set it as default
echo "Installing SDDM (KDE Login Manager)..."
sudo apt install -y sddm || { echo "Failed to install SDDM!"; exit 1; }

# Set SDDM as the default display manager
echo "Configuring SDDM as the default login manager..."
sudo systemctl disable lightdm.service || { echo "Failed to disable LightDM!"; exit 1; }
sudo systemctl disable gdm.service || { echo "Failed to disable GDM!"; exit 1; }
sudo systemctl enable sddm.service || { echo "Failed to enable SDDM!"; exit 1; }

# Install Mint Themes
echo "Cloning the Mint Themes repository..."
git clone https://github.com/linuxmint/mint-themes.git || { echo "Failed to clone Mint Themes repository!"; exit 1; }

echo "Building and installing Mint Themes..."
cd mint-themes || { echo "Failed to navigate into the mint-themes directory!"; exit 1; }
make || { echo "Failed to build the themes!"; exit 1; }
sudo cp -r usr/share/themes/* /usr/share/themes/ || { echo "Failed to move the themes to /usr/share/themes!"; exit 1; }
cd ..
echo "Mint Themes have been successfully installed to /usr/share/themes!"
echo "You can now apply the themes via your desktop environment's settings."

# Install bootloader themes from Chris Titus Tech
echo "Cloning the Bootloader Themes repository..."
git clone https://github.com/ChrisTitusTech/Top-5-Bootloader-Themes || { echo "Failed to clone bootloader themes repository!"; exit 1; }

echo "Installing bootloader themes..."
cd Top-5-Bootloader-Themes || { echo "Failed to navigate into the Top-5-Bootloader-Themes directory!"; exit 1; }
sudo ./install.sh || { echo "Failed to install bootloader themes!"; exit 1; }
cd ..

# Add Flathub repository for Flatpak
echo "Adding Flathub repository for Flatpak..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || { echo "Failed to add Flathub repository!"; exit 1; }

# Reboot message with countdown
echo "Your system will be rebooted in:"
for i in {5..1}
do
   echo "$i"
   sleep 1
done

echo "Thanks for running this script brought to you by X27 and Chris Titus Tech. Enjoy!"
sudo reboot
