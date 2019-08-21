# QGIS Server 3.x Vagrant testing VMs with Apache and Nginx

Yet another QGIS Server demo VM, initially prepared for Nødebo QGIS
confererence and workshop 2017 this new version uses QGIS 3
and offers new deployment strategies:

+ Apache Fast CGI
+ Apache CGI
+ Nginx Fast CGI
+ Nginx load balancing proxy to Python wsgi

A mapproxy demo is also installed.

> Note: this VM was not designed for production but for demonstration purposes only.


## Requirements

You need a working installation of Vagrant with Virtualbox.

Please follow the installation instructions here:

https://www.virtualbox.org/wiki/Downloads
https://www.vagrantup.com/docs/installation/

For disk resizing you will also need the Vagrant plugin `vagrant-disksize`, you can install the plugin with:

```
vagrant plugin install vagrant-disksize
```

> Note: if you have any issue installing `vagrant-disksize` plugin on Linux, you can try to upgrade Vagrant with the following command (adapt the version numbers to the newest available release)

```
wget -c https://releases.hashicorp.com/vagrant/2.0.3/vagrant_2.0.3_x86_64.deb
sudo dpkg -i vagrant_2.0.3_x86_64.deb
```


## Features

This machine is based on Ubuntu bionic and comes with a sample project and some sample plugins.


| Server            | Port       | Mapped to |
|---                |---         |---        |
| Nginx FastCGI     | 80         | 8080      |
| Apache (Fast)CGI  | 81         | 8081      |
| Nginx Python      | 82         | 8082      |
| Nginx mapproxy    | 83         | 8083      |


### Apache2 (Fast)CGI stack

- Apache2
- FastCGI with `mod_fcgid`
- CGI with `mod_cgid`

### Nginx FastCGI stack

- Nginx
- systemd

### Nginx Python stack

- Nginx
- Systemd

### Plugins

- HTTP Basic Auth (for WFS protection)
- GetFeatureInfo HTML formatter
- Simple Browser
- XYZ

## Documentation

A presentation is available in the [docs directory](docs/index.rst)

## Setup

From the directory that contains this `README`:

```
vagrant up
```

Follow the steps in the documentation for further setup.


### Details of the provisioning scripts

The provisioning scripts are contained in the directory `provisioning`.

The common configuration for all the scripts is in `config.sh`.

The main script is `setup.sh` which calls all the other scripts.

