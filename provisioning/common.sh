#!/bin/bash
# Provisioning file for Vagrant

# Common setup for all servers

. /vagrant/provisioning/config.sh

echo "Changing QGIS_SERVER_DIR to ${QGIS_SERVER_DIR} ..."

# Add QGIS repositories
apt-key adv --keyserver keyserver.ubuntu.com --recv-key CAEB3DC3BDF7FB45
echo 'deb http://qgis.org/debian bionic main' > /etc/apt/sources.list.d/debian-gis.list

# Update && upgrade packages
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get -y upgrade

# Install the software
apt-get -y install qgis-server python-qgis xvfb ipython3

# Install utilities (optional)
apt-get -y install vim unzip

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
