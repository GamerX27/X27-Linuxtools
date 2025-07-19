#!/bin/bash

# Fedora Post Install many of the commands are from TechHut https://www.youtube.com/watch?v=RrRpXs2pkzg
# This script automates post-installation steps for Fedora.

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root (e.g., using sudo)."
    exit 1
fi

echo "Starting Fedora post-installation script..."

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

# 3. Enable RPM Fusion (Check if already enabled)
echo "Checking for RPM Fusion repositories..."

FREE_REPO="/etc/yum.repos.d/rpmfusion-free.repo"
NONFREE_REPO="/etc/yum.repos.d/rpmfusion-nonfree.repo"

if [[ -f "$FREE_REPO" && -f "$NONFREE_REPO" ]]; then
    echo "RPM Fusion repositories already enabled. Skipping..."
else
    echo "Enabling RPM Fusion repositories..."
    dnf5 install -y \
        https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    echo "RPM Fusion repositories enabled."
fi

dnf5 group update core -y

# 4. Adding Flatpaks (Check if Flathub is present)
echo "Setting up Flatpak support..."

dnf5 install -y flatpak

if flatpak remote-list | grep -q flathub; then
    echo "Flathub repository already exists. Skipping..."
else
    echo "Adding Flathub repository..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

echo "Flatpak support configured."

# 5. Brave Browser Installation
if command -v flatpak &> /dev/null; then
    read -p "Do you want to install Brave browser? (y/n): " INSTALL_BRAVE
    if [ "$INSTALL_BRAVE" == "y" ]; then
        echo "Choose installation method for Brave:"
        echo "1) Flatpak (Flathub)"
        echo "2) Brave's official install script (via curl)"
        read -p "Enter 1 or 2: " BRAVE_METHOD

        if [ "$BRAVE_METHOD" == "1" ]; then
            echo "Installing Brave via Flatpak..."
            flatpak install -y flathub com.brave.Browser
        elif [ "$BRAVE_METHOD" == "2" ]; then
            echo "Installing Brave using Brave's official install script..."
            if ! command -v curl &> /dev/null; then
                echo "curl is not installed. Installing curl..."
                dnf5 install -y curl
            fi
            curl -fsS https://dl.brave.com/install.sh | sh
        else
            echo "Invalid option. Skipping Brave installation."
        fi
    else
        echo "Skipping Brave browser installation."
    fi
fi

# 6. Change Hostname (Optional)
read -p "Do you want to change the hostname? (y/n): " CHANGE_HOSTNAME
if [ "$CHANGE_HOSTNAME" == "y" ]; then
    read -p "Enter new hostname: " NEW_HOSTNAME
    if [ -z "$NEW_HOSTNAME" ]; then
        echo "No hostname entered. Skipping hostname change."
    else
        hostnamectl set-hostname "$NEW_HOSTNAME"
        echo "Hostname changed to $NEW_HOSTNAME"
    fi
else
    echo "Skipping hostname change."
fi

# 7. Install Media Codecs
echo "Installing media codecs..."

dnf5 groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
dnf5 groupupdate sound-and-video -y

echo "Media codecs installed."

# 8. NVIDIA Drivers with Secure Boot (Optional)
read -p "Do you want to install NVIDIA proprietary drivers with Secure Boot support? (y/n): " INSTALL_NVIDIA
if [ "$INSTALL_NVIDIA" == "y" ]; then
    echo "Installing NVIDIA drivers with Secure Boot support..."
    dnf5 install -y akmod-nvidia
    echo "Configuring Secure Boot with mokutil..."
    mokutil --import /etc/pki/akmods/certs/kmod-nvidia.der
    echo "Please reboot your system and follow the prompts to complete the driver installation."
else
    echo "Skipping NVIDIA driver installation."
fi

# 9. Power Profile Configuration
echo "Configuring power profile using tuned..."
dnf5 install -y tuned
tuned-adm profile balanced
echo "Tuned set to balanced profile."

echo "Fedora post-installation steps completed."
