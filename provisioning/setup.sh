#!/bin/bash
# Provisioning file for Vagrant
# Install the software


set -e

export LC_ALL=C 
export DEBIAN_FRONTEND=noninteractive

sudo adduser vagrant sudo

# Fix DNS for gnupg import key
sed -i -e 's/nameserver.*/nameserver 8.8.8.8/' /etc/resolv.conf

# Call provisioning scripts
. /vagrant/provisioning/common.sh
. /vagrant/provisioning/nginx.sh
. /vagrant/provisioning/apache2.sh

# Clean
apt-get autoremove -y
apt-get clean
