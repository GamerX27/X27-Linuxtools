#!/bin/bash

# Add the Testing repository
echo "deb http://ftp.no.debian.org/debian/ testing main contrib non-free" | sudo tee -a /etc/apt/sources.list

# Configure APT Pinning
sudo tee /etc/apt/preferences.d/00pinning > /dev/null <<EOF
Package: *
Pin: release a=stable
Pin-Priority: 900

Package: *
Pin: release a=testing
Pin-Priority: 100

Package: cinnamon*
Pin: release a=testing
Pin-Priority: 910

Package: muffin*
Pin: release a=testing
Pin-Priority: 910

Package: nemo*
Pin: release a=testing
Pin-Priority: 910

Package: linux-image-*
Pin: release a=testing
Pin-Priority: 910
EOF

# Update the package list
sudo apt update

# Upgrade existing packages if needed
# sudo apt upgrade -y

# Install libcurl4 from the stable repository
sudo apt install libcurl4 -y

# Install curl from the stable repository
sudo apt install curl -y

# Install LightDM and Slick Greeter
sudo apt install lightdm slick-greeter -y

# Install Cinnamon desktop environment from the testing branch
sudo apt install -t testing cinnamon-core -y

# Install htop and Git
sudo apt install -y htop git

# Install Flatpak and add Flathub repository
sudo apt install flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Update package list
sudo apt update

# Install Eye of MATE image viewer
sudo apt install eom -y

# Install Papirus icon theme
sudo apt install papirus-icon-theme -y

# Install Synaptic package manager
sudo apt install synaptic -y

# Install Distrobox
sudo apt install distrobox -y

# Install Docker.io, Linux kernel from the testing repository, and fish shell and stacer
sudo apt install -y docker.io fish stacer
sudo apt install -t testing linux-image-amd64 -y
sudo apt dist-upgrade -y

# Remove Podman if installed
if dpkg -l | grep -q podman; then
  sudo apt purge podman -y
fi

# Final update and upgrade
sudo apt update && sudo apt upgrade -y

echo "Script execution completed."

# Add the current user to the docker group
sudo usermod -aG docker $USER

# Install bootloader themes from Chris Titus Tech
git clone https://github.com/ChrisTitusTech/Top-5-Bootloader-Themes
cd Top-5-Bootloader-Themes
sudo ./install.sh
cd ..

# Additional configurations and installations can go here
# Reboot message with countdown
echo "Your system will be rebooted in:"
for i in {5..1}
do
   echo "$i"
   sleep 1
done

echo "Thanks for running my script brought to you by X27 and Chris Titus Tech. Enjoy!"
sudo reboot
