#!/usr/bin/env bash

unset HISTFILE

# Blank line for sudo prompt
echo ""

# Install software
echo "Installing software..."
yum install -y nano git source-highlight wget policycoreutils-python

# Disable i2c_piix4 to get rid of boot warnings
sleep 30
if [[ $(lsmod | grep i2c_piix4) ]]; then
	echo "Applying Bootfix..."
	echo blacklist i2c_piix4 >> /etc/modprobe.d/blacklist.conf
fi

# STIG the system
echo "STIGing it up..."
oscap xccdf eval --remediate --profile xccdf_org.ssgproject.content_profile_stig-rhel7-disa --fetch-remote-resources /usr/share/xml/scap/ssg/content/ssg-centos7-ds.xml > /dev/null
sed -i 's/ sha1//g' /usr/lib/dracut/modules.d/01fips/module-setup.sh
sed -i 's/ sha1_s390//g' /usr/lib/dracut/modules.d/01fips/module-setup.sh
dracut -f
sed -i 's/repo_gpgcheck=1/repo_gpgcheck=0/g' /etc/yum.conf  # So we can use epel-rlease

# Install update script
wget -O /usr/bin/update https://raw.githubusercontent.com/fights-on/update-scripts/master/Unix/centos.sh
chmod +x /usr/bin/update

# Fix bashrc's permissions
mv /tmp/.bashrc /root/.bashrc
mv /tmp/.nanorc /root/.nanorc
echo "Applying .bashrc's..."
chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.bashrc
chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.nanorc
chown root:root /root/.bashrc
chown root:root /root/.nanorc

# Clean up
echo "Cleaning up..."
yum autoremove -y
yum clean all
rm -rf /var/chache/yum
rm -rf /root/anaoconda-ks.cfg original-ks.cfg VBoxGuestAdditions.iso

# Disable Root
echo "Disabling root..."
passwd -d root
passwd -l root
