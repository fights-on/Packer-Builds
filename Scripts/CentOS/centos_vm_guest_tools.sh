#!/usr/bin/env bash

unset HISTFILE

# Install VM Guest Tools
if [ $PACKER_BUILDER_TYPE = "vmware-iso" ]; then
  echo "Installing Open-VM-Tools..."
  sudo yum install -y dkms open-vm-tools open-vm-tools-dkms
elif [ $PACKER_BUILDER_TYPE = "virtualbox-iso" ]; then
  echo "Installing VirtualBox Guest Additions..."
  sudo mkdir /media/VirtualBoxGuestAdditions
  sudo mount -r /dev/sr1 /media/VirtualBoxGuestAdditions
  KERN_DIR=/usr/src/kernels/`uname -r`/build
  /media/VirtualBoxGuestAdditions/VBoxLinuxAdditions.run
  umount /media/VirtualBoxGuestAdditions
  rm -rf /media/VirtualBoxGuestAdditions
fi

echo "Rebooting..."
sudo reboot
