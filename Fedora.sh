#!/bin/bash

# Fedora Post Install Script by Techut - Updated for Fedora 41
# This script automates the post-installation steps for Fedora 41.

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root (e.g., using sudo)."
    exit 1
fi

echo "Starting Fedora 41 post-installation script..."

# 1. DNF5 Configuration
echo "Configuring DNF5..."

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

echo "DNF5 configuration updated."

# Clear DNF cache
echo "Clearing DNF cache..."
dnf5 clean all

# 2. System Update
echo "Updating the system..."
dnf5 update -y

# 3. Enable RPM Fusion
echo "Enabling RPM Fusion repositories..."

dnf5 install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf5 group update core -y

echo "RPM Fusion repositories enabled."

# 4. Adding Flatpaks
echo "Adding Flatpak support..."

dnf5 install -y flatpak

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

dnf5 groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
dnf5 groupupdate sound-and-video -y

echo "Media codecs installed."

# 7. NVIDIA Drivers with Secure Boot (Optional)
read -p "Do you need to install NVIDIA proprietary drivers with Secure Boot support? (y/n): " INSTALL_NVIDIA
if [ "$INSTALL_NVIDIA" == "y" ]; then
    echo "Installing NVIDIA drivers with Secure Boot support..."
    dnf5 install -y akmod-nvidia
    echo "Configuring Secure Boot with mokutil..."
    mokutil --import /etc/pki/akmods/certs/kmod-nvidia.der
    echo "Please reboot your system and follow the prompts to complete the driver installation."\else
    echo "Skipping NVIDIA driver installation."
fi

# 8. Power Profile Configuration
echo "Configuring power profile using tuned..."
dnf5 install -y tuned
tuned-adm profile balanced
echo "Tuned set to balanced profile."

echo "Fedora 41 post-installation steps completed."
