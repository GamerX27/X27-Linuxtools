#!/bin/bash

# Function to display the menu
show_menu() {
    echo "==================================="
    echo "         X27 Linuxtools Menu       "
    echo "==================================="
    echo "1) X27Debian"
    echo "2) X27Debian-Testing"
    echo "3) FlatpakX27"
    echo "4) Exit"
    echo "==================================="
}

# Function to download and run X27Debian script
run_x27debian() {
    echo "Running X27Debian..."
    curl -O https://raw.githubusercontent.com/GamerX27/X27-Linuxtools/main/X27Debian.sh
    chmod +x X27Debian.sh
    ./X27Debian.sh
}

# Function to download and run X27Debian-Testing script
run_x27debian_testing() {
    echo "Running X27Debian-Testing..."
    curl -O https://raw.githubusercontent.com/GamerX27/X27-Linuxtools/main/X27Debian-Testing.sh
    chmod +x X27Debian-Testing.sh
    ./X27Debian-Testing.sh
}

# Function to download and run FlatpakX27 script
run_flatpak_x27() {
    echo "Running FlatpakX27..."
    curl -O https://raw.githubusercontent.com/GamerX27/X27-Linuxtools/main/FlatpaksX27.sh
    chmod +x FlatpaksX27.sh
    ./FlatpaksX27.sh
}

# Main loop
while true; do
    show_menu
    read -p "Please select an option: " choice

    case $choice in
        1)
            run_x27debian
            ;;
        2)
            run_x27debian_testing
            ;;
        3)
            run_flatpak_x27
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done
