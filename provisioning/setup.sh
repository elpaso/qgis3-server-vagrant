#!/bin/bash
# Provisioning file for Vagrant
# Install the software

set -e

# Load configuration
. /vagrant/provisioning/config.sh


export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive

# Fix DNS for gnupg import key
sed -i -e 's/nameserver.*/nameserver 8.8.8.8/' /etc/resolv.conf

# Call provisioning scripts
echo "Runnig provisioning scripts ..."
/vagrant/provisioning/common.sh
/vagrant/provisioning/apache2.sh
/vagrant/provisioning/nginx.sh
/vagrant/provisioning/mapproxy.sh

# Clean
echo "Cleaning up ..."
apt-get autoremove -y
apt-get clean

echo "All done!"