#!/bin/bash

# Update system using pacman
sudo pacman -Syu --noconfirm

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

# Install Octopi via AUR using yay
yay -S --noconfirm octopi

# Install additional applications via Flatpak using yay for AUR
yay -S --noconfirm flatpak

# Install Flatpak applications
flatpak install flathub org.onlyoffice.desktopeditors -y
flatpak install flathub org.kde.krita -y
flatpak install flathub com.github.tchx84.Flatseal -y
flatpak install flathub com.heroicgameslauncher.hgl -y
flatpak install flathub org.kde.kwrite -y
flatpak install flathub io.github.Qalculate -y

# Your existing setup commands...

# Ensure default home directory structure
create_directory() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
    echo "Directory $1 created."
  else
    echo "Directory $1 already exists."
  fi
}

create_directory ~/Desktop
create_directory ~/Documents
create_directory ~/Music
create_directory ~/Pictures
create_directory ~/Videos
create_directory ~/Downloads

# Final system cleanup
yay -Sc --noconfirm
sudo pacman -Sc --noconfirm

# Final system cleanup
yay -Sc --noconfirm
sudo pacman -Sc --noconfirm

echo "Setup complete. You may reboot your system for all changes to take effect."
