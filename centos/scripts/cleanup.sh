#!/bin/bash
#
# ------------------------------------------------------------------------------
# Cleanup base box
# ------------------------------------------------------------------------------
#

# remove network mac and interface information
sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i '/^UUID/d' /etc/sysconfig/network-scripts/ifcfg-eth0

# remove any ssh keys or persistent routes, dhcp leases
rm -f /etc/ssh/ssh_host_*
rm -f /etc/udev/rules.d/70-persistent-net.rules
rm -f /var/lib/dhclient/dhclient-eth0.leases
rm -rf /tmp/*
yum -y clean all

# disable reverse DNS lookups on sshd
sed -i 's/.*UseDNS.*/UseDNS no/' /etc/ssh/sshd_config
