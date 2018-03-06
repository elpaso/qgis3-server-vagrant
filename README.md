# QGIS Server 3.x Vagrant testing VMs with Apache and Nginx

Yet another QGIS Server demo VM, initially prepared for Nødebo QGIS 
confererence and workshop 2017 this new version uses QGIS 3
and offers new deployment strategies:

+ Apache Fast CGI
+ Apache CGI
+ Nginx Fast CGI
+ Nginx load balancing proxy to Python wsgi

A mapproxy demo is also installed.

## Requirements

You need a working installation of Vagrant with Virtualbox.

Please follow the installation instructions here:

https://www.vagrantup.com/docs/installation/
https://www.virtualbox.org/wiki/Downloads

For disk resizing you will also need the Vagrant plugin `vagrant-disksize`, you can install the plugin with:

    vagrant plugin install vagrant-disksize


## Features

This machine is based on xenial and comes with a sample project and some sample plugins.


| Server            | Port       | Mapped to |
|---                |---         |---        |
| Nginx FastCGI     | 80         | 8080      |
| Nginx Python      | 82         | 8082      |
| Apache (Fast)CGI  | 81         | 8081      |
| Nginx mapproxy    | 83         | 8083      |


### Apache2 (Fast)CGI stack

- Apache2
- FastCGI with mod_fcgid
- CGI with mod_cgid

### Nginx FastCGI stack

- nginx
- systemd

### Nginx Python stack

- nginx
- systemd

### Plugins

- HTTP Basic Auth (for WFS protection)
- GetFeatureInfo HTML formatter
- Simple Browser
- XYZ

## Documentation

A presentation is available in the [docs directory](docs/index.rst)

## Setup

From the directory that contains this README:

```
vagrant up
```

Follow the steps in the documentation for further setup.



