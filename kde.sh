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

# Flatpak support for discover
sudo apt install -y plasma-discover-backend-flatpak

# Ask the user if they want the latest KDE desktop and kernel from the testing branch
read -p "Do you want the latest KDE desktop and kernel from the testing branch? (yes/no): " response

if [[ "$response" == "yes" ]]; then
    # Pin the most known packages to the testing branch
    sudo apt install -y -t testing kde-plasma-desktop linux-image-amd64
fi

# Clean up
sudo apt autoremove -y

# Add wallpaper
wget https://wallpapercave.com/wp/wp9142720.jpg

# Install stuff
sudo apt install curl -y

echo "Setup complete! Please reboot your system to apply all changes."
