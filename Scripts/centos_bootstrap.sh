#!/usr/bin/env bash

unset HISTFILE

# Install software
echo "Installing software..."
yum install -y nano git source-highlight wget policycoreutils-python

# Disable i2c_piix4 to get rid of boot warnings
sleep 30
if [[ $(sudo lsmod | grep i2c_piix4) ]]; then
	echo "Applying Bootfix..."
	sudo echo blacklist i2c_piix4 >> /etc/modprobe.d/blacklist.conf
fi

# STIG the system
echo "STIGing it up..."
sudo oscap xccdf eval --remediate --profile xccdf_org.ssgproject.content_profile_stig-rhel7-disa --fetch-remote-resources /usr/share/xml/scap/ssg/content/ssg-centos7-ds.xml > /dev/null
sudo sed -i 's/ sha1//g' /usr/lib/dracut/modules.d/01fips/module-setup.sh
sudo sed -i 's/ sha1_s390//g' /usr/lib/dracut/modules.d/01fips/module-setup.sh
sudo dracut -f
sudo sed -i 's/repo_gpgcheck=1/repo_gpgcheck=0/g' /etc/yum.conf  # So we can use epel-rlease

# Install update script
wget -O /usr/bin/update https://raw.githubusercontent.com/fights-on/update-scripts/master/Unix/centos.sh
chmod +x /usr/bin/update

# Fix bashrc's permissions
sudo mv /tmp/.bashrc /root/.bashrc
sudo mv /tmp/.nanorc /root/.nanorc
echo "Applying .bashrc's..."
sudo chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.bashrc
sudo chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.nanorc
sudo chown root:root /root/.bashrc
sudo chown root:root /root/.nanorc

# Clean up
echo "Cleaning up..."
sudo yum autoremove -y
sudo yum clean all
sudo rm -rf /var/chache/yum
sudo rm -rf /root/anaoconda-ks.cfg original-ks.cfg VBoxGuestAdditions.iso

# Disable Root
echo "Disabling root..."
sudo passwd -d root
sudo passwd -l root
