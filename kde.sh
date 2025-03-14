#!/bin/bash

# Update the package list and upgrade all packages
sudo apt update
sudo apt upgrade -y

# Ask user if they want the latest KDE and kernel from the testing branch
read -p "Do you want to enable the testing branch for the latest KDE and kernel? (y/n): " enable_testing

if [[ "$enable_testing" == "y" || "$enable_testing" == "Y" ]]; then
    echo "Adding the testing repository..."
    echo "deb http://deb.debian.org/debian testing main contrib non-free" | sudo tee -a /etc/apt/sources.list
    
    # Create a preference file to pin KDE, the kernel, and known packages to the testing branch
    echo "Creating pinning preferences..."
    sudo tee /etc/apt/preferences.d/testing.pref <<EOF
Package: *
Pin: release a=testing
Pin-Priority: 100

Package: kde-plasma-desktop
Pin: release a=testing
Pin-Priority: 900

Package: plasma-desktop
Pin: release a=testing
Pin-Priority: 900

Package: kde-standard
Pin: release a=testing
Pin-Priority: 900

Package: linux-image-amd64
Pin: release a=testing
Pin-Priority: 900
EOF
    
    # Update package list after adding the testing repo
    sudo apt update
    
    # Install KDE Plasma Desktop and latest kernel from testing
    sudo apt install -y kde-standard linux-image-amd64
fi

# Install KDE Plasma Desktop if not already installed from testing
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

# Flatpak support for Discover
sudo apt install -y plasma-discover-backend-flatpak

# Clean up
sudo apt autoremove -y

# Add wallpaper
wget https://wallpapercave.com/wp/wp9142720.jpg

# Install additional utilities
sudo apt install curl -y

echo "Setup complete! Please reboot your system to apply all changes."
