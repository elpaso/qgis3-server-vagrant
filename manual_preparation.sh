sudo sh -c 'echo "qgis     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'
sudo apt install unzip
wget https://github.com/elpaso/qgis3-server-vagrant/archive/master.zip
unzip master.zip
rm master.zip
sudo mv  qgis3-server-vagrant-master/ /vagrant

# Become root and cd to /vagrant/provisioning
# run download_only.sh
