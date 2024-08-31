#!/bin/bash

# Update system and install base development tools
sudo pacman -Syu --noconfirm
sudo pacman -S --needed base-devel git --noconfirm

# Install xdg-user-dirs-gtk to manage user directories
sudo pacman -S --noconfirm xdg-user-dirs-gtk

# Continue with the rest of the setup

# Install core Cinnamon utilities (excluding Pix) using pacman
sudo pacman -S --noconfirm nemo xreader gnome-terminal cinnamon-control-center cinnamon-settings-daemon cinnamon-session muffin cinnamon-screensaver

# Install GTK-friendly replacements for GNOME core applications using pacman
sudo pacman -S --noconfirm orage gnome-disk-utility font-manager mate-system-monitor xfce4-logs mate-image-viewer flameshot

# Install VLC via pacman
sudo pacman -S --noconfirm vlc

# Install file archiving utilities using pacman
sudo pacman -S --noconfirm file-roller unrar p7zip unzip

# Install system monitoring tools using pacman
sudo pacman -S --noconfirm htop gnome-disk-utility

# Replace gnome-weather with a weather app compatible with Cinnamon (Cinnamon Weather Applet) using pacman
sudo pacman -S --noconfirm cinnamon-weather-applet

# Install Timeshift for system backups using pacman
sudo pacman -S --noconfirm timeshift

# Install Octopi via pacman
#sudo pacman -S --noconfirm octopi

# Install Flatpak if not already installed
sudo pacman -S --noconfirm flatpak

# Install Flatpak applications
flatpak install flathub org.onlyoffice.desktopeditors -y
flatpak install flathub org.kde.krita -y
flatpak install flathub com.github.tchx84.Flatseal -y
flatpak install flathub com.heroicgameslauncher.hgl -y
flatpak install flathub org.kde.kwrite -y
flatpak install flathub io.github.Qalculate -y

# Install GNOME Platform Locale 43 via Flatpak
#flatpak install flathub org.gnome.Platform.Locale//43 -y

# Final system cleanup
sudo pacman -Sc --noconfirm

echo "Setup complete. You may reboot your system for all changes to take effect."

# Install additional core Cinnamon packages (if any were missing)
sudo pacman -S --noconfirm cinnamon-desktop cinnamon-menus cinnamon-translations

# Additional useful tools
sudo pacman -S --noconfirm gnome-keyring network-manager-applet

# Optional: Uncomment to install additional themes and icons (e.g., Mint themes)
# sudo pacman -S --noconfirm mint-themes mint-x-icons mint-y-icons
