#!/bin/bash

# Update the package list and upgrade all packages
sudo apt update
sudo apt upgrade -y

# Install KDE Plasma Desktop
sudo apt install -y kde-standard

# Backup the current sources list
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

# Add contrib and non-free to sources list
sudo sed -i 's/main/main contrib non-free/' /etc/apt/sources.list

# Update the package list again
sudo apt update

# Install Papirus icon theme
sudo apt install -y papirus-icon-theme

# Install Flatpak
sudo apt install -y flatpak

# Add the Flathub repository
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Discover (Plasma's software center) with Flatpak support
sudo apt install -y discover discover-flatpak-backend

# Clean up
sudo apt autoremove -y

echo "Setup complete! Please reboot your system to apply all changes."
