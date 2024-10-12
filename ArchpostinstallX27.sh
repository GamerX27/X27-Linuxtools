#!/bin/bash

# Arch Linux Mint Post-Installation Script (Without Mint Themes)
# This script sets up a Linux Mint-like experience on an Arch Linux base system with Cinnamon already installed.
# It installs necessary dependencies, LightDM with slick-greeter, and LightDM GTK Greeter Settings GUI.
# Optionally, it can install Mint themes from AUR using yay.

# Function to install core dependencies (vala and meson)
install_core_dependencies() {
    echo "Installing core dependencies (vala, meson)..."
    sudo pacman -S --needed vala meson --noconfirm
}

# Function to install all required dependencies and minimal apps
install_dependencies_and_minimal_apps() {
    echo "Installing necessary packages and minimal Ubuntu-like applications..."
    
    # Install core packages for slick-greeter, lightdm, theming, and LightDM settings GUI
    sudo pacman -S --needed ninja gtk3 libcanberra lightdm libx11 cairo xapp wget \
                         gtk-engine-murrine sassc git lightdm-gtk-greeter-settings python-pysassc --noconfirm

    # Install minimal Ubuntu-like applications, excluding unnecessary terminals and editors
    sudo pacman -S --needed networkmanager gnome-disk-utility file-roller evince gnome-system-monitor --noconfirm
}


# Function to install the slick greeter for LightDM
install_slick_greeter() {
    echo "Installing slick greeter..."
    # Clone the slick-greeter repository from Linux Mint and build it
    git clone https://github.com/linuxmint/slick-greeter.git /tmp/slick-greeter
    cd /tmp/slick-greeter
    meson build --prefix=/usr || { echo "Meson build failed"; exit 1; }
    ninja -C build || { echo "Ninja build failed"; exit 1; }
    sudo ninja -C build install || { echo "Ninja install failed"; exit 1; }
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
echo "Starting the Arch Linux Mint post-installation setup..."

# Step 1: Install core dependencies (vala and meson)
install_core_dependencies

# Step 2: Install necessary dependencies and minimal Ubuntu-like applications
install_dependencies_and_minimal_apps

# Step 3: Prompt to install Mint themes from the AUR
install_mint_themes

# Step 4: Install and configure LightDM slick greeter
install_slick_greeter
configure_lightdm_greeter

# Step 5: Clean up temporary files
cleanup

# Final message
echo "Arch Linux Mint post-installation setup completed! You can now reboot to experience your new setup."
