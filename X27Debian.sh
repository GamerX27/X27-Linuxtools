#!/bin/bash

# Step 1: Clone the Mint Themes repository
echo "Cloning the Mint Themes repository..."
git clone https://github.com/linuxmint/mint-themes.git || { echo "Failed to clone repository!"; exit 1; }

# Step 2: Navigate into the Mint Themes directory
cd mint-themes || { echo "Failed to navigate into the mint-themes directory!"; exit 1; }

# Step 3: Install pysassc
echo "Installing pysassc..."
sudo apt update
sudo apt install -y pysassc || { echo "Failed to install pysassc!"; exit 1; }

# Step 4: Build the themes
echo "Building the themes..."
make || { echo "Failed to build the themes!"; exit 1; }

# Step 5: Move the compiled themes to /usr/share/themes (root)
echo "Moving the compiled themes to /usr/share/themes..."
sudo cp -r usr/share/themes/* /usr/share/themes/ || { echo "Failed to move the themes to /usr/share/themes!"; exit 1; }

echo "Themes have been successfully installed to /usr/share/themes!"
echo "You can now apply the themes via your desktop environment's settings."

# Exit successfully
exit 0
