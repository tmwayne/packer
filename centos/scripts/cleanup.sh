#!/bin/bash -x
#
# ------------------------------------------------------------------------------
# Cleanup base box
# ------------------------------------------------------------------------------
#

# remove network mac and interface information
echo 'remove network mac' > /home/tyler/status.txt
sed -i \
  -e '/HWADDR/d' \
  -e '/^UUID/d' \
  /etc/sysconfig/network-scripts/ifcfg-eth0

# disable reverse DNS lookups and password authentication
# TODO: these are deleting the /etc/ssh/sshd_config files
echo 'modify sshd_config' >> /home/tyler/status.txt
sed --in-place='.bk' \
  -e '/UseDNS/d' \
  -e '/PasswordAuthentication/d' \
  /etc/ssh/sshd_config
echo 'UseDNS no' >> /etc/ssh/sshd_config
echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config

echo 'remove extras' >> /home/tyler/status.txt
# remove any ssh keys or persistent routes, dhcp leases
rm -f /etc/udev/rules.d/70-persistent-net.rules
rm -f /var/lib/dhclient/dhclient-eth0.leases
# rm -rf /tmp/*
# yum -y clean all

systemctl restart sshd
