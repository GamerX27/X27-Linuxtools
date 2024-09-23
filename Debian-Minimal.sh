#!/bin/bash
# Update package lists
sudo apt update

# Upgrade current packages
sudo apt upgrade -y

# Install essential tools with Cinnamon-core for a minimal Cinnamon desktop
sudo apt install -y \
    xorg \
    cinnamon-core \  # Minimal Cinnamon desktop
    network-manager \
    network-manager-gnome \
    gnome-terminal \
    nemo \
    firefox-esr \
    pulseaudio \
    alsa-utils \
    gvfs-backends \
    bash-completion \
    xdg-user-dirs \
    gedit \
    xviewer \  # Image viewer for Cinnamon
    synaptic \  # Synaptic package manager
    lightdm \
    lightdm-slick-greeter \  # Slick-greeter for LightDM
    flatpak \  # Flatpak support
    unzip \
    git \
    make \
    pysassc  # Required for building Mint themes

# Enable Flatpak and add Flathub repository
echo "Setting up Flatpak..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "Flatpak support has been installed and Flathub added as a repository."

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

# Enable and configure LightDM with slick-greeter
echo "Configuring LightDM with slick-greeter..."
sudo systemctl enable lightdm
sudo sed -i 's/^#greeter-session=.*$/greeter-session=slick-greeter/' /etc/lightdm/lightdm.conf
echo "LightDM has been configured to use slick-greeter."

# Cleanup unnecessary files
sudo apt autoremove -y
sudo apt clean

echo "Minimal Cinnamon Debian setup with Mint Themes, Synaptic, Flatpak, and LightDM (slick-greeter) completed. Rebooting now."
sudo reboot
