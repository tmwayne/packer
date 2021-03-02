#!/bin/bash
#
# ------------------------------------------------------------------------------
# Set up Vagrant access for base box
# ------------------------------------------------------------------------------
#
# Tyler Wayne © 2020
#

echo 'vagrant   ALL=(ALL)   NOPASSWD: ALL' >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant
sed -i 's/^.*requiretty/#Defaults requiretty/' /etc/sudoers

mkdir -m 0700 /home/vagrant/.ssh
curl --silent --output /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# yum install -y ntp gcc make kernel-headers kernel-devel dkms bzip2
# systemctl enable ntpd.service
# systemctl enable sshd.service
