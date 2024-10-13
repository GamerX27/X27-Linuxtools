#!/bin/bash

# Script to install GNOME core with additional apps on Arch Linux

echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing GNOME core packages..."
sudo pacman -S --noconfirm gnome-shell gnome-control-center gnome-session gnome-settings-daemon mutter gdm

echo "Installing additional GNOME applications..."
sudo pacman -S --noconfirm nautilus gedit totem alacarte evince baobab eog seahorse gnome-translation-editor gnome-terminal

echo "Enabling GDM (GNOME Display Manager)..."
sudo systemctl enable gdm

echo "Starting GDM..."
sudo systemctl start gdm

echo "GNOME core and additional applications installation complete. Rebooting now..."
sudo reboot
