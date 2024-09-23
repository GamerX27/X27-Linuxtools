#!/bin/bash
# Script to install various packages, Mint Themes, and add Flathub repository for Flatpak

# Update and install packages
sudo apt update
sudo apt install -y curl htop flatpak papirus-icon-theme synaptic distrobox pysassc build-essential xdg-user-dirs xdg-user-dirs-gtk make

# Add Flathub repository for Flatpak
echo "Adding Flathub repository for Flatpak..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || { echo "Failed to add Flathub repository!"; exit 1; }

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

# Ask for reboot
echo "Installation complete. Do you want to reboot now? (y/n)"
read -r answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo "Rebooting..."
    sudo reboot
else
    echo "Reboot canceled. You can reboot later by typing 'sudo reboot'."
fi
