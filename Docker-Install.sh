#!/bin/bash

# Download the Docker installation script
curl -fsSL https://get.docker.com -o get-docker.sh

# Make the script executable (optional, for added security)
chmod +x get-docker.sh

# Run the Docker installation script with superuser privileges
sudo sh get-docker.sh

# Optionally, clean up the downloaded script after installation
rm get-docker.sh

# Confirm Docker was installed correctly
docker --version
