#!/usr/bin/env bash

unset HISTFILE

# Install Repos
echo "Install Repos..."
sudo yum install -y epel-release deltarpm

# Install repositories and update
echo "Updating..."
sudo yum update -y 2>/dev/null  # Hide deltarpm warnings

# Install VBox Addition's Dependencies
if [ $PACKER_BUILDER_TYPE = "virtualbox-iso" ]; then
  echo "Installing VirtualBox Guest Additions Dependencies..."
  sudo yum install -y gcc kernel-devel kernel-headers dkms make bzip2 perl
fi

echo "Rebooting..."
sudo reboot
