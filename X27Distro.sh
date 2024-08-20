#!/bin/bash

# Define colors for better visibility
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Display the big text at the top
echo -e "${GREEN}"
echo "============================================"
echo "   X27Distro by X27"
echo "   Source codes from Chris Titus"
echo "============================================"
echo -e "${NC}"

# Ask if the user has already completed the desktop installation and rebooted
read -p "Have you already completed the initial desktop installation and rebooted? (yes/no): " choice

if [[ $choice != "yes" ]]; then
    echo -e "${GREEN}Proceeding with the desktop installation...${NC}"

    # Make sure the script is run as root
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root (use sudo)."
        exit
    fi

    # Add testing branch to sources.list
    echo "deb http://deb.debian.org/debian testing main contrib non-free" > /etc/apt/sources.list.d/testing.list

    # Set APT preferences to install only specific packages from testing
    cat <<EOF > /etc/apt/preferences.d/testing
Package: *
Pin: release a=testing
Pin-Priority: 100

Package: kde-plasma-desktop
Pin: release a=testing
Pin-Priority: 990

Package: linux-image-*
Pin: release a=testing
Pin-Priority: 990

Package: distrobox
Pin: release a=testing
Pin-Priority: 990

EOF

    # Update package lists
    apt update

    # Install KDE Plasma desktop with no recommended packages
    apt install -t testing kde-plasma-desktop --no-install-recommends -y

    # Install the kernel from the testing branch
    apt install -t testing linux-image-amd64 -y

    # Install distrobox from the testing branch
    apt install -t testing distrobox -y

    # Install essential packages for a functional KDE setup
    apt install dolphin terminator sddm plasma-nm --no-install-recommends -y

    # Install Eye of MATE image viewer and ensure good GTK integration on KDE
    apt install eom kde-gtk-config gtk2-engines-murrine -y

    # Install Flatpak and add the Flathub repository
    apt install flatpak -y
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    # Install KDE Discover with Flatpak backend for integration
    apt install plasma-discover plasma-discover-backend-flatpak -y

    # Install bootloader themes from Chris Titus Tech
    git clone https://github.com/ChrisTitusTech/Top-5-Bootloader-Themes
    cd Top-5-Bootloader-Themes
    sudo ./install.sh
    cd ..

    # Install Fish shell and set it as the default for the current user
    apt install fish -y
    chsh -s /usr/bin/fish $(whoami)

    # Install the Papirus icon theme and Materia KDE theme
    apt install materia-kde papirus-icon-theme -y

    # Apply the Materia theme and Papirus icons
    lookandfeeltool -a Materia
    plasma-apply-wallpaperimage --wallpaper /usr/share/wallpapers/Materia/contents/images/1920x1080.jpg

    # Clean up
    apt autoremove -y
    apt clean

    echo "Desktop installation complete. Please reboot your system and then run this script again to proceed with Flatpak installations."

else
    echo -e "${GREEN}Proceeding with Flatpak application installations...${NC}"

    # Function to print a header
    print_header() {
        echo -e "${GREEN}"
        echo "============================================"
        echo "   Installing Flatpak Applications"
        echo "============================================"
        echo -e "${NC}"
    }

    # Function to print a footer
    print_footer() {
        echo -e "${GREEN}"
        echo "============================================"
        echo "   Installation Complete"
        echo "============================================"
        echo -e "${NC}"
    }

    # Function to install a Flatpak application
    install_flatpak() {
        local app=$1
        echo -e "${GREEN}Installing ${app}...${NC}"
        flatpak install -y flathub ${app}
        echo -e "${GREEN}${app} installed successfully!${NC}\n"
    }

    # Main script execution
    print_header

    # List of applications to install
    apps=(
        org.onlyoffice.desktopeditors
        org.kde.krita
        org.videolan.VLC
        com.github.tchx84.Flatseal
        com.usebottles.bottles
        org.kde.kwrite
        io.github.Qalculate
        com.vivaldi.Vivaldi
        org.gnome.Platform.Locale//43
        org.mozilla.firefox
        io.github.dvlv.boxbuddyrs
    )

    # Loop through the list and install each application
    for app in "${apps[@]}"; do
        install_flatpak $app
    done

    print_footer

    # Ask the user if they want to reboot the system
    read -p "Installation is complete. Would you like to reboot the system now? (yes/no): " reboot_choice
    if [[ $reboot_choice == "yes" ]]; then
        sudo reboot
    else
        echo -e "${GREEN}You can reboot the system later to complete the setup.${NC}"
    fi
fi

# Display credits at the end
echo -e "${GREEN}"
echo "==================================================="
echo "Credits:"
echo "X27Distro by X27"
echo "Source codes from Chris Titus Tech - https://github.com/GamerX27"
echo "Bootloader themes provided by Chris Titus Tech - https://www.youtube.com/@ChrisTitusTech"
echo "==================================================="
echo -e "${NC}"
