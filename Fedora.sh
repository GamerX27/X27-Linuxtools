#!/bin/bash

# Fedora Post Install Script by Techut
# This script automates the post-installation steps for Fedora.

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root (e.g., using sudo)."
    exit 1
fi

echo "Starting Fedora post-installation script..."

# 1. DNF Configuration
echo "Configuring DNF..."

# Backup existing dnf.conf
if [ -f /etc/dnf/dnf.conf ]; then
    cp /etc/dnf/dnf.conf /etc/dnf/dnf.conf.bak
    echo "Backed up existing /etc/dnf/dnf.conf to /etc/dnf/dnf.conf.bak"
fi

# Add configurations to /etc/dnf/dnf.conf if not already present
DNF_CONF="/etc/dnf/dnf.conf"

grep -qxF 'fastestmirror=True' "$DNF_CONF" || echo 'fastestmirror=True' >> "$DNF_CONF"
grep -qxF 'max_parallel_downloads=10' "$DNF_CONF" || echo 'max_parallel_downloads=10' >> "$DNF_CONF"
grep -qxF 'defaultyes=True' "$DNF_CONF" || echo 'defaultyes=True' >> "$DNF_CONF"
grep -qxF 'keepcache=True' "$DNF_CONF" || echo 'keepcache=True' >> "$DNF_CONF"

echo "DNF configuration updated."

# Clear DNF cache
echo "Clearing DNF cache..."
dnf clean all

# 2. System Update
echo "Updating the system..."
dnf update -y

# 3. Enable RPM Fusion
echo "Enabling RPM Fusion repositories..."

dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.p
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.p

dnf group update core -y

echo "RPM Fusion repositories enabled."

# 4. Adding Flatpaks
echo "Adding Flatpak support..."

dnf install -y flatpak

# Add Flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Flatpak support added."

# 5. Change Hostname
echo "Changing hostname..."

# Prompt for new hostname
read -p "Enter new hostname: " NEW_HOSTNAME

if [ -z "$NEW_HOSTNAME" ]; then
    echo "No hostname entered. Skipping hostname change."
else
    hostnamectl set-hostname "$NEW_HOSTNAME"
    echo "Hostname changed to $NEW_HOSTNAME"
fi

# 6. Install Media Codecs
echo "Installing media codecs..."

dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
dnf groupupdate sound-and-video -y

echo "Media codecs installed."
