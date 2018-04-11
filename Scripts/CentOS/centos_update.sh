#!/usr/bin/env bash

unset HISTFILE

# Blank line for sudo prompt
echo ""

# Install Repos
echo "Install Repos..."
yum install -y epel-release deltarpm

# Install repositories and update
echo "Updating..."
yum update -y 2>/dev/null  # Hide deltarpm warnings

# Install VBox Addition's Dependencies
if [ $PACKER_BUILDER_TYPE = "virtualbox-iso" ]; then
  echo "Installing VirtualBox Guest Additions Dependencies..."
  yum install -y gcc kernel-devel kernel-headers dkms make bzip2 perl
fi

echo "Rebooting..."
reboot
