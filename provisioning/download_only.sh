#!/bin/bash
# This is a partial provisioning script that download most
# of the dependencies without installing, it can be useful
# for workshop VM preparation to speed-up setup.


set -e

. /vagrant/provisioning/config.sh

echo "Setting up development apt repositories ..."

# Add QGIS repositories
apt-key adv --keyserver keyserver.ubuntu.com --recv-key 51F523511C7028C3
echo 'deb http://qgis.org/ubuntu-nightly bionic main' > /etc/apt/sources.list.d/ubuntu-qgis.list

# Update && upgrade packages
apt-get update && apt-get -y upgrade

echo "Downloading dependencies without installing ..."

# Download the software
apt-get -y install --download-only \
    qgis-server \
    python3-qgis \
    xvfb \
    vim \
    unzip \
    ipython3 \
    apache2 \
    libapache2-mod-fcgid \
    nginx \
    uwsgi \
    python3-pil \
    python3-yaml \
    libproj12 \
    python3-shapely \
    python3-pip


