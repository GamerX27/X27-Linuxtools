#!/bin/bash

# Script to install GNOME core on Arch Linux

echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing GNOME core packages..."
sudo pacman -S --noconfirm gnome-shell gnome-control-center gnome-session gnome-settings-daemon mutter nautilus gdm

echo "Enabling GDM (GNOME Display Manager)..."
sudo systemctl enable gdm

echo "Starting GDM..."
sudo systemctl start gdm

echo "GNOME core installation complete. Rebooting now..."
sudo reboot
