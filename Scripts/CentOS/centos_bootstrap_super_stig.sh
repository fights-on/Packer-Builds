#!/usr/bin/env bash

USER_ACCOUNT="cpt"

unset HISTFILE

# Disable i2c_piix4 to get rid of boot warnings
if [[ $(sudo lsmod | grep i2c_piix4) ]]; then
	echo "Applying Bootfix..."
	sudo echo blacklist i2c_piix4 >> /etc/modprobe.d/blacklist.conf
fi

# Install utilities
echo "Installing tools..."
sudo yum install -y nano git source-highlight wget aide mailx policycoretils-python scap-security-guide openscap-scanner

# STIG the system
echo "STIGing it up..."
# xccdf_org.ssgproject.content_profile_stig-rhel7-disa
sudo echo '05 4 * * * root /usr/sbin/aide --check | /bin/mail -s "$(hostname) - AIDE Integrity Check" root@localhost' >> /etc/crontab
#sudo echo 'FIPSR = p+i+n+u+g+s+m+c+acl+selinux+xattrs+sha256' >> /etc/aide.conf
#sudo echo 'NORMAL = FIPSR+sha512' >> /etc/aide.conf
#sudo dracut -f
#sudo sed -i 's|GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=vg00/lv_root rd.lvm.lv=vg00/lv_swap rhgb quiet rd.shell=0 fips=1"|g' /etc/default/grub
#sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo oscap xccdf eval --remediate --profile xccdf_org.ssgproject.content_profile_stig-rhel7-disa --fetch-remote-resources /usr/share/xml/scap/ssg/content/ssg-centos7-ds.xml > /dev/null
sudo sed -i 's/ sha1//g' /usr/lib/dracut/modules.d/01fips/module-setup.sh
sudo sed -i 's/ sha1_s390//g' /usr/lib/dracut/modules.d/01fips/module-setup.sh
sudo dracut -f
sudo sed -i 's/repo_gpgcheck=1/repo_gpgcheck=0/g' /etc/yum.conf
#sudo sed -i 's/^gpgcheck=0/gpgcheck=1/g' /etc/yum.conf
#sudo echo 'localpkg_gpgcheck=1' >> /etc/yum.conf
#sudo echo "install usb-storage /bin/true" >> /etc/modprobe.d
#sudo echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf
#sudo semanage login -a -s sysadm_u c $USER_ACCOUNT
#sudo sed -i 's/ nullok//g' /etc/pam.d/system-auth
#sudo chage -M 180 -m 1 -W 7  -I 180 cpt
#sudo sed -i 's/PASS_MIN_DAYS 0/PASS_MIN_DAYS 1/g' /etc/login.defs
#sudo sed -i 's/PASS_MAX_DAYS 99999/PASS_MAX_DAYS 60/g' /etc/login.defs

# Install update script

# Fix bashrc's permissions
echo "Applying .bashrc's..."
sudo chown cpt:cpt /home/cpt/.bashrc
sudo chown cpt:cpt /home/cpt/.nanorc
sudo chown root:root /root/.bashrc
sudo chown root:root /root/.nanorc

# Clean up
echo "Cleaning up..."
sudo yum autoremove -y
sudo yum clean all
sudo rm -rf /var/chache/yum
sudo rm -rf /root/anaoconda-ks.cfg original-ks.cfg VBoxGuestAddiitons.iso

# Disable Root
echo "Disabling root..."
sudo passwd -d root
sudo passwd -l root

# Secure RPMs
# echo "Securing RPMs..."
# declare -a rpm_array
# if [[ $(sudo rpm -Va | grep '^.M') ]]; then
	# for x in `sudo rpm -Va | grep '^.M' | awk '{print $3}' | sudo xargs rpm -qf`; do
		
		# if [[ ! "${rpm_array[@]}" =~ "${x}" ]]; then
			# rpm_array=("${rpm_array[@]}" "$x")
		# fi
	# done
	# for x in "${rpm_array[@]}"; do
		# sudo rpm --setperms $x
	# done
# fi

# declare -a rpm_array
# if [[ $(sudo rpm -Va | grep '^.....\(U\|.G\)') ]]; then
	# for x in `sudo rpm -Va | grep '^.....\(U\|.G\)' | awk '{print $3}' | sudo xargs rpm -qf`; do
		# echo $x
		# if [[ ! "${rpm_array[@]}" =~ "${x}" ]]; then
			# rpm_array=("${rpm_array[@]}" "$x")
		# fi
	# done
	# for x in "${rpm_array[@]}"; do
		# sudo rpm --setgids $x
	# done
# fi

# declare -a rpm_array
# if [[ $(sudo rpm -Va | grep '^..5') ]]; then
	# for x in `sudo rpm -Va | grep '^..5' | awk '{print $3}' | sudo xargs rpm -qf`; do
		# if [[ ! "${rpm_array[@]}" =~ "${x}" ]]; then
			# rpm_array=("${rpm_array[@]}" "$x")
		# fi
	# done
	# for x in "${rpm_array[@]}"; do
		# sudo rpm --Uvh $x
	# done
# fi

# Init/Update aide
echo "Initializing AIDE..."
sudo aide -i
sudo mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
