#!/bin/bash
#By X27

# Check if the script is run with sudo
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Create the debupgrade script
cat <<EOF > /bin/debupgrade
#!/bin/bash
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
EOF

# Make the debupgrade script executable
chmod +x /bin/debupgrade

echo "debupgrade command has been created and is ready to use."

# Run debupgrade for the first time
debupgrade
