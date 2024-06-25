#!/bin/bash

# Define colors for better visibility
GREEN='\033[0;32m'
NC='\033[0m' # No Color

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
)

# Loop through the list and install each application
for app in "${apps[@]}"; do
    install_flatpak $app
done

print_footer
