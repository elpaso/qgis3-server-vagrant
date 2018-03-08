#!/bin/bash
# Provisioning file for Vagrant: nginx

set -e

. /vagrant/provisioning/config.sh

echo "Changing QGIS_SERVER_DIR to ${QGIS_SERVER_DIR} ..."

# Install the software
export DEBIAN_FRONTEND=noninteractive
apt-get -y install nginx uwsgi

# Configure the web server
if [ -e /etc/nginx/sites-enabled/default ]; then
   rm /etc/nginx/sites-enabled/default
fi

cp /vagrant/resources/nginx/qgis-* /etc/nginx/sites-enabled

# Configure FastCGI nginx conf
sed -i -e "s@QGIS_SERVER_DIR@${QGIS_SERVER_DIR}@g" /etc/nginx/sites-enabled/qgis-server-fcgi
SOCKETS=''
for i in $( eval echo {1..$NUM_PROCESSES}); do SOCKETS="    server unix:/run/qgis_mapserv$i.sock;\n$SOCKETS" ; done
sed -i -e "s@QGIS_SERVER_SOCKETS@${SOCKETS}@g" /etc/nginx/sites-enabled/qgis-server-fcgi


# Configure python nginx conf
sed -i -e "s@QGIS_SERVER_DIR@${QGIS_SERVER_DIR}@g" /etc/nginx/sites-enabled/qgis-server-python
SOCKETS=''
for i in $( eval echo {1..$NUM_PROCESSES}); do SOCKETS="    server 127.0.0.1:809$i;\n$SOCKETS" ; done
sed -i -e "s@QGIS_SERVER_HTTP_SERVERS@${SOCKETS}@g" /etc/nginx/sites-enabled/qgis-server-python
cp /vagrant/resources/uwsgi/*.py ${QGIS_SERVER_DIR}
chmod +x ${QGIS_SERVER_DIR}/*.py


# Configure systemd
cp /vagrant/resources/systemd/*.* /etc/systemd/system/
sed -i -e "s@QGIS_SERVER_DIR@${QGIS_SERVER_DIR}@g" /etc/systemd/system/qgis-server-fcgi@.service
sed -i -e "s@QGIS_SERVER_DIR@${QGIS_SERVER_DIR}@g" /etc/systemd/system/qgis-server-fcgi@.socket
/bin/bash -c "systemctl enable qgis-server-fcgi@{1..${NUM_PROCESSES}}.socket && systemctl start qgis-server-fcgi@{1..${NUM_PROCESSES}}.socket"
/bin/bash -c "systemctl enable qgis-server-fcgi@{1..${NUM_PROCESSES}}.service && systemctl start qgis-server-fcgi@{1..${NUM_PROCESSES}}.service"
# No socket for python
sed -i -e "s@QGIS_SERVER_DIR@${QGIS_SERVER_DIR}@g" /etc/systemd/system/qgis-server-python@.service
/bin/bash -c "systemctl enable qgis-server-python@{1..${NUM_PROCESSES}}.service && systemctl start qgis-server-python@{1..${NUM_PROCESSES}}.service"

systemctl restart nginx.service
