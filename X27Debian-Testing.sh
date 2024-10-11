#!/bin/bash

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Install LightDM and Slick Greeter
echo "Installing LightDM and Slick Greeter..."
sudo apt install -y lightdm slick-greeter || { echo "Failed to install LightDM and Slick Greeter!"; exit 1; }

# Enable LightDM as the default display manager
echo "Configuring LightDM as the default display manager..."
sudo systemctl enable lightdm || { echo "Failed to enable LightDM!"; exit 1; }
sudo dpkg-reconfigure lightdm

# Install Cinnamon desktop environment
echo "Installing Cinnamon desktop environment..."
sudo apt install -y cinnamon-core || { echo "Failed to install Cinnamon desktop environment!"; exit 1; }

# Install necessary packages
echo "Installing necessary packages..."
sudo apt install -y git libcurl4 curl htop flatpak eom papirus-icon-theme synaptic distrobox pysassc build-essential xdg-user-dirs xdg-user-dirs-gtk #plasma-discover #plasma-discover-backend-flatpak || { echo "Failed to install necessary packages!"; exit 1; }

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

# Install bootloader themes from Chris Titus Tech
echo "Cloning the Bootloader Themes repository..."
git clone https://github.com/ChrisTitusTech/Top-5-Bootloader-Themes || { echo "Failed to clone bootloader themes repository!"; exit 1; }

echo "Installing bootloader themes..."
cd Top-5-Bootloader-Themes || { echo "Failed to navigate into the Top-5-Bootloader-Themes directory!"; exit 1; }
sudo ./install.sh || { echo "Failed to install bootloader themes!"; exit 1; }
cd ..

# Add Flathub repository for Flatpak
echo "Adding Flathub repository for Flatpak..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || { echo "Failed to add Flathub repository!"; exit 1; }

# Reboot message with countdown
echo "Your system will be rebooted in:"
for i in {5..1}
do
   echo "$i"
   sleep 1
done

echo "Thanks for running this script brought to you by X27 and Chris Titus Tech. Enjoy!"
sudo reboot

# Function to install the slick greeter for LightDM
install_slick_greeter() {
    echo "Installing slick greeter..."
    # Clone the slick-greeter repository from Linux Mint and build it
    git clone https://github.com/linuxmint/slick-greeter.git /tmp/slick-greeter
    cd /tmp/slick-greeter
    meson build --prefix=/usr
    ninja -C build
    sudo ninja -C build install
}

# Function to configure LightDM and set the greeter wallpaper and settings
configure_lightdm_greeter() {
    echo "Configuring LightDM slick greeter..."

    # Download the desired wallpaper for the greeter
    sudo wget -O /usr/share/backgrounds/greeter-wallpaper.jpg https://wallpaperaccess.com/full/1167973.jpg

    # Configure slick-greeter settings in /etc/lightdm/slick-greeter.conf
    sudo bash -c 'cat > /etc/lightdm/slick-greeter.conf <<EOF
[Greeter]
background=/usr/share/backgrounds/greeter-wallpaper.jpg
theme-name=Mint-Y-Dark
icon-theme-name=Mint-Y
font-name=Sans 12
cursor-theme-name=Adwaita
panel-logo=/usr/share/icons/hicolor/128x128/apps/lightdm.png
clock-format=%H:%M %p
show-a11y=false
show-keyboard=false
show-power=false
draw-user-backgrounds=false
draw-grid=false
EOF'
}

# Function to clean up temporary directories used during installation
cleanup() {
    echo "Cleaning up temporary files..."
    # Remove the temporary directories created during installation
    rm -rf /tmp/slick-greeter
}

# Main execution flow
echo "Starting the Debian Testing post-installation setup..."

# Step 1: Install necessary dependencies and minimal applications
sudo apt update && sudo apt upgrade -y
sudo apt install -y lightdm git meson ninja-build wget cmake build-essential libgtk-3-dev libgee-0.8-dev liblightdm-gobject-1-dev libx11-dev libgdk-pixbuf2.0-dev libglib2.0-dev

# Step 2: Install and configure LightDM slick greeter
install_slick_greeter
configure_lightdm_greeter

# Step 3: Clean up temporary files
cleanup

# Final message
echo "Debian Testing post-installation setup completed! You can now reboot to experience your new setup."
