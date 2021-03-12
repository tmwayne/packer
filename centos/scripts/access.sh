#!/bin/bash -x
#
# ------------------------------------------------------------------------------
# Set up Vagrant access for base box
# ------------------------------------------------------------------------------
#
# Tyler Wayne © 2021
#

echo 'tyler   ALL=(ALL)   NOPASSWD: ALL' >> /etc/sudoers.d/tyler
chmod 0440 /etc/sudoers.d/tyler
# sed -i 's/^.*requiretty/#Defaults requiretty/' /etc/sudoers

mkdir -m 0700 /home/tyler/.ssh
mv /tmp/key.pub /home/tyler/.ssh/authorized_keys
# curl --silent ${PACKER_HTTP_ADDR}/key.pub > /home/tyler/.ssh/authorized_keys
chmod 0600 /home/tyler/.ssh/authorized_keys
chown -R tyler:tyler /home/tyler/.ssh
