#!/bin/bash

# Forked from https://github.com/BryanDollery/remove-snap by BryanDollery
# Modified by X27 to include Flatpak setup, reboot countdown, and user prompts

echo "Removing snap..."

# Stop the snapd daemon
sudo systemctl disable --now snapd

# Uninstall snapd
sudo apt purge -y snapd

# Remove leftover directories
sudo rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd ~/snap

# Prevent snapd from being reinstalled automatically
cat << EOF | sudo tee /etc/apt/preferences.d/no-snap.pref > /dev/null
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

# Ensure correct ownership
sudo chown root:root /etc/apt/preferences.d/no-snap.pref

echo "✅ Snap removed successfully."

# Ask the user which desktop environment they are using
echo
read -p "Are you using GNOME or KDE? [gnome/kde]: " desktop_env

case "$desktop_env" in
    gnome|GNOME)
        echo "Installing GNOME Flatpak plugin..."
        sudo apt install -y gnome-software-plugin-flatpak
        ;;
    kde|KDE)
        echo "Installing KDE Discover Flatpak backend..."
        sudo apt install -y plasma-discover-backend-flatpak
        ;;
    *)
        echo "Unknown desktop environment. Skipping Flatpak plugin installation."
        ;;
esac

# Add Flathub remote if it doesn't exist
echo "Adding Flathub repository..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Optional reminder
echo
echo "💡 Tip: After reboot, explore Flathub apps for a cleaner, ad-free experience."

# Confirm if user wants to reboot
echo
read -p "Do you want to reboot now to finalize the changes? [y/n]: " reboot_choice
if [[ "$reboot_choice" =~ ^[Yy]$ ]]; then
    echo
    echo "Rebooting in 5 seconds... Press Ctrl+C to cancel."
    for i in {5..1}; do
        echo "$i..."
        sleep 1
    done
    echo "♻️ Rebooting now!"
    sudo reboot
else
    echo "Reboot skipped. You may need to reboot later."
fi

echo
echo "✅ All done. Credits: BryanDollery, X27"
