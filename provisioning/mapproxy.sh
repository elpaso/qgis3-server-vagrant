#!/bin/bash
# Install and configure mapproxy

set -e

. /vagrant/provisioning/config.sh

echo "Changing QGIS_SERVER_DIR to ${QGIS_SERVER_DIR} ..."

# Install the software

apt-get install -y python3-pil python3-yaml libproj12 python3-shapely python3-pip
pip3 install virtualenv

MAPPROXY_DIR=${QGIS_SERVER_DIR}/mapproxy

if [ ! -e ${MAPPROXY_DIR} ]; then
    mkdir -p ${MAPPROXY_DIR}
fi

virtualenv --system-site-packages ${MAPPROXY_DIR}
source ${MAPPROXY_DIR}/bin/activate
pip3 install MapProxy

pushd .

cd ${MAPPROXY_DIR}
mapproxy-util create -t base-config --force myconfig
mapproxy-util create -t wsgi-app --force -f myconfig/mapproxy.yaml myconfig.py
# Overwrite with prepared configuration
cp /vagrant/resources/mapproxy/mapproxy.yaml ${MAPPROXY_DIR}/myconfig/

popd


# Install the software
apt-get -y install nginx uwsgi

# Configure mapp nginx conf
cp /vagrant/resources/nginx/mapproxy /etc/nginx/sites-enabled
sed -i -e "s@QGIS_SERVER_DIR@${QGIS_SERVER_DIR}@g" /etc/nginx/sites-enabled/mapproxy
SOCKETS=''
for i in $( eval echo {1..$NUM_PROCESSES}); do SOCKETS="    server 127.0.0.1:810$i;\n$SOCKETS" ; done
sed -i -e "s@QGIS_SERVER_HTTP_SERVERS@${SOCKETS}@g" /etc/nginx/sites-enabled/mapproxy
cp /vagrant/resources/uwsgi/*.py ${QGIS_SERVER_DIR}
chmod +x ${QGIS_SERVER_DIR}/*.py


sed -i -e "s@QGIS_SERVER_DIR@${QGIS_SERVER_DIR}@g" /etc/systemd/system/mapproxy@.service

echo "Changing MAPPROXY_DIR to ${MAPPROXY_DIR} ..."

sed -i -e "s@MAPPROXY_DIR@${MAPPROXY_DIR}@g" /etc/systemd/system/mapproxy@.service
/bin/bash -c "systemctl enable mapproxy@{1..${NUM_PROCESSES}}.service && systemctl start mapproxy@{1..${NUM_PROCESSES}}.service"


chown -R www-data.www-data ${MAPPROXY_DIR}

systemctl restart nginx.service


