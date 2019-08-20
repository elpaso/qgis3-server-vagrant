#!/bin/bash
# Provisioning file for Vagrant

# Common setup for all servers

set -e

. /vagrant/provisioning/config.sh

echo "Changing QGIS_SERVER_DIR to ${QGIS_SERVER_DIR} ..."

# Add QGIS repositories
apt-key adv --keyserver keyserver.ubuntu.com --recv-key 51F523511C7028C3
echo 'deb http://qgis.org/ubuntu-nightly bionic main' > /etc/apt/sources.list.d/ubuntu-qgis.list

# Update && upgrade packages
apt-get update && apt-get -y upgrade

# Install the software
# Temporary workaround: overwrite is required because of a packaging bug
apt-get -y install -o Dpkg::Options::="--force-overwrite" qgis-server python3-qgis xvfb

# Install utilities (optional)
apt-get -y install vim unzip ipython3

# Install sample projects and plugins
mkdir -p $QGIS_SERVER_DIR/logs
cp -r /vagrant/resources/web/htdocs $QGIS_SERVER_DIR
cp -r /vagrant/resources/web/plugins $QGIS_SERVER_DIR
cp -r /vagrant/resources/web/projects $QGIS_SERVER_DIR
chown -R www-data.www-data $QGIS_SERVER_DIR
sed -i -e "s@QGIS_SERVER_DIR@${QGIS_SERVER_DIR}@g" $QGIS_SERVER_DIR/htdocs/index.html

# Setup xvfb
cp /vagrant/resources/xvfb/xvfb.service /etc/systemd/system/xvfb.service
systemctl enable /etc/systemd/system/xvfb.service
systemctl start xvfb

# Symlink to cgi for apache CGI mode
[ -f /usr/lib/cgi-bin/qgis_mapserv.cgi ] || ln -s /usr/lib/cgi-bin/qgis_mapserv.fcgi /usr/lib/cgi-bin/qgis_mapserv.cgi
