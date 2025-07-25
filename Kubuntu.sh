#!/bin/bash

# Kubuntu setup script with media support, Flatpak, Brave browser, essential apps, and optional Snap removal

set -euo pipefail

echo "🔧 Starting Kubuntu setup..."

# Step 1: Enable multiverse repository
echo "📦 Adding multiverse repository..."
sudo add-apt-repository -y multiverse

# Step 2: Update package lists
echo "🔄 Updating package lists..."
sudo apt update

# Step 3: Install multimedia codecs and essential apps
echo "🎵 Installing kubuntu-restricted-extras, fastfetch, VLC, and Papirus icon theme..."
sudo apt install -y \
  kubuntu-restricted-extras \
  fastfetch \
  vlc \
  papirus-icon-theme

# Step 4: Install Flatpak and KDE Discover Flatpak support
echo "📦 Installing Flatpak and KDE Discover Flatpak support..."
sudo apt install -y flatpak plasma-discover-backend-flatpak

# Step 5: Add Flathub repository
echo "🌐 Adding Flathub..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Step 6: Install Brave browser using official script
echo "🦁 Installing Brave browser..."
if command -v curl > /dev/null 2>&1; then
  curl -fsS https://dl.brave.com/install.sh | sh
else
  echo "❌ curl not found. Installing curl first..."
  sudo apt install -y curl
  curl -fsS https://dl.brave.com/install.sh | sh
fi

# Step 7: Check and remove Snap if installed
if command -v snap >/dev/null 2>&1; then
  echo "🧹 Snap is installed. Removing Snap..."

  # Stop the Snap daemon
  sudo systemctl disable --now snapd || true

  # Uninstall Snap
  sudo apt purge -y snapd

  # Remove leftover directories
  sudo rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd ~/snap

  # Prevent reinstallation of Snap
  echo "📛 Blocking Snap from being reinstalled..."
  cat << EOF | sudo tee /etc/apt/preferences.d/no-snap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
  sudo chown root:root /etc/apt/preferences.d/no-snap.pref

  echo "✅ Snap removed and blocked from reinstalling."
else
  echo "✔️ Snap is not installed. Skipping removal..."
  # Still block it from being installed accidentally
  echo "📛 Preventing Snap from being installed..."
  cat << EOF | sudo tee /etc/apt/preferences.d/no-snap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
  sudo chown root:root /etc/apt/preferences.d/no-snap.pref
fi

echo "✅ Kubuntu setup complete!"
