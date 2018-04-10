#!/usr/bin/env bash

unset HISTFILE

# Install Repos
echo "Install Repos..."
sudo yum install -y epel-release deltarpm

# Install repositories and update
echo "Updating..."
sudo yum update -y 2>/dev/null  # Hide deltarpm warnings
echo "Rebooting..."
sudo reboot