:data-transition-duration: 2000
:skip-help: true
:css: css/custom.css

.. title:: QGIS Server Workshop 2018

.. header::

   .. image:: images/qgis-icon.png


.. footer::

    Introduction to QGIS Server Workshop 2018

----


Supporteds standards
====================

+ WMS 1.3 
+ WFS 1.0.0, 1.1.0 (currently broken) 
+ WCS 1.1.1 

----

Compliance tests
================

OGC CITE Compliance Testing

CI tests:

http://37.187.164.233/ogc/

----

Architecture
=============

`SERVICE` modules

+ WMS
+ WFS
+ WCS
+ custom modules (C++ and Python)

+ Python plugins
+ Python bindings

----

API
===

https://qgis.org/api/group__server.html

----

OS Setup
====================

We are using Ubuntu Bionic 64bit

https://github.com/elpaso/qgis3-server-vagrant

in Vagrant it is provided by the *box*:

https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64-vagrant.box


Quickstart:

.. code:: bash

    vagrant up

----

SSH into the machine
====================

.. code:: bash

    vagrant ssh
    sudo su -

**Checkpoint**: you need to be able to log into the machine and become `root`

----

Add resources from workshop repository
======================================

Only for unprovisioned machines!

.. code:: bash

    wget https://github.com/elpaso/qgis3-server-vagrant/archive/master.zip
    unzip master.zip 
    rmdir /vagrant/
    mv qgis3-server-vagrant-master/ /vagrant

----

Add required repositories
=========================

.. code:: bash

    # Add QGIS repositories
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key CAEB3DC3BDF7FB45
    echo 'deb http://qgis.org/debian bionic main' > /etc/apt/sources.list.d/debian-gis.list
    apt-get update && apt-get -y upgrade

----

Add required repositories
=========================

**Checkpoint**: the available version of qgis-server must be >= 3 from qgis.org

.. code:: bash

    apt-cache policy qgis-server
    qgis-server:
        Installed: 1:3.0.0+28bionic
        Candidate: 1:3.0.0+28bionic
        Version table:
        *** 1:3.0.0+28bionic 500
            500 http://qgis.org/debian bionic/main amd64 Packages

----

Install system software
=======================

Install the software

.. code:: bash

    export DEBIAN_FRONTEND=noninteractive
    apt-get -y install qgis-server python-qgis xvfb

    # Install utilities (optional)
    apt-get -y install vim unzip ipython3


----

Install system software I
===========================

**Checkpoint**: qgis installed with no errors, you can check it with

.. code:: bash

    /usr/lib/cgi-bin/qgis_mapserv.fcgi 2> /dev/null
    Content-Length: 54
    Content-Type: text/xml; charset=utf-8
    Server:  Qgis FCGI server - QGis version 3.0.0-Girona
    Status:  500

    <ServerException>Project file error</ServerException>


----

Install system software II
===========================


.. code:: bash

    # Install sample projects and plugins
    mkdir -p $QGIS_SERVER_DIR/logs
    cp -r /vagrant/resources/web/htdocs $QGIS_SERVER_DIR
    cp -r /vagrant/resources/web/plugins $QGIS_SERVER_DIR
    cp -r /vagrant/resources/web/projects $QGIS_SERVER_DIR
    chown -R www-data.www-data $QGIS_SERVER_DIR


----

Install system software III
=============================

.. code:: bash

    # Setup xvfb
    cp /vagrant/resources/xvfb/xvfb.service \
        /etc/systemd/system/xvfb.service
    systemctl enable /etc/systemd/system/xvfb.service
    service xvfb start

    # Symlink to cgi for apache CGI mode
    ln -s /usr/lib/cgi-bin/qgis_mapserv.fcgi \
        /usr/lib/cgi-bin/qgis_mapserv.cgi

----

Apache2
======================

Installation (with FCGI module)

.. code:: bash 

    # Common configuration
    export QGIS_SERVER_DIR=/qgis-server

    # Install the required server software
    export DEBIAN_FRONTEND=noninteractive
    apt-get -y install apache2 libapache2-mod-fcgid


-----

Apache2 configuration I
=========================

Configure the web server

.. code:: bash 

    cp /vagrant/resources/apache2/001-qgis-server.conf \
        /etc/apache2/sites-available
    sed -i -e "s@QGIS_SERVER_DIR@${QGIS_SERVER_DIR}@g" \
        /etc/apache2/sites-available/001-qgis-server.conf
    sed -i -e 's/VirtualHost \*:80/VirtualHost \*:81/' \
        /etc/apache2/sites-available/001-qgis-server.conf
    sed -i -e "s@QGIS_SERVER_DIR@${QGIS_SERVER_DIR}@g" \
        $QGIS_SERVER_DIR/htdocs/index.html



-----

Apache2 configuration II
=========================

VirtualHost configuration for both **FastCGI** and **CGI**

.. code:: bash

    <VirtualHost *:81>
        
        # [ ... ] Standard config goes here

        # Longer timeout for WPS... default = 40
        FcgidIOTimeout 120
        FcgidInitialEnv LC_ALL "en_US.UTF-8"
        FcgidInitialEnv LANG "en_US.UTF-8"
        FcgidInitialEnv PYTHONIOENCODING UTF-8
        FcgidInitialEnv QGIS_DEBUG 1
        FcgidInitialEnv QGIS_SERVER_LOG_FILE "QGIS_SERVER_DIR/logs/qgis-apache-001.log"
        FcgidInitialEnv QGIS_SERVER_LOG_LEVEL 0
        FcgidInitialEnv QGIS_PLUGINPATH "QGIS_SERVER_DIR/plugins"
        FcgidInitialEnv QGIS_AUTH_DB_DIR_PATH "QGIS_SERVER_DIR"
        FcgidInitialEnv QGIS_OPTIONS_PATH "QGIS_SERVER_DIR"
        FcgidInitialEnv QGIS_CUSTOM_CONFIG_PATH "QGIS_SERVER_DIR"
        FcgidInitialEnv DISPLAY ":99"

-----

Apache2 configuration IV
=========================

**CGI**

.. code:: bash

        # For simple CGI: ignored by fcgid
        SetEnv LC_ALL "en_US.UTF-8"
        SetEnv LANG "en_US.UTF-8"
        SetEnv PYTHONIOENCODING UTF-8
        SetEnv QGIS_DEBUG 1
        SetEnv QGIS_SERVER_LOG_FILE "QGIS_SERVER_DIR/logs/qgis-apache-001.log"
        SetEnv QGIS_SERVER_LOG_LEVEL 0
        SetEnv QGIS_PLUGINPATH "QGIS_SERVER_DIR/plugins"
        SetEnv QGIS_AUTH_DB_DIR_PATH "QGIS_SERVER_DIR"
        SetEnv QGIS_OPTIONS_PATH "QGIS_SERVER_DIR"
        SetEnv QGIS_CUSTOM_CONFIG_PATH "QGIS_SERVER_DIR"
        SetEnv DISPLAY ":99"

----

Apache2 configuration V
=========================

.. code:: bash

        # Needed for QGIS plugin HTTP BASIC auth
        <IfModule mod_fcgid.c>
            RewriteEngine on
            RewriteCond %{HTTP:Authorization} .
            RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
        </IfModule>

        ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
        <Directory "/usr/lib/cgi-bin">
            AllowOverride All
            Options +ExecCGI -MultiViews +FollowSymLinks
            Allow from all
            AddHandler cgi-script .cgi
            AddHandler fcgid-script .fcgi
            Require all granted        
        </Directory>

    </VirtualHost>
        
-----

Apache2 configuration VI
=========================

Enable sites and restart

.. code:: bash

    a2enmod rewrite # Only required by some plugins
    a2enmod cgid # Required by plain old CGI
    a2dissite 000-default 
    a2ensite 001-qgis-server

    # Listen on port 81 instead of 80 (nginx)
    sed -i -e 's/Listen 80/Listen 81/' /etc/apache2/ports.conf
   
    service apache2 restart # Restart the server


**Checkpoint**: check wether Apache is listening on localhost port 8081 http://localhost:8081

----

Nginx Installation
===================

.. code:: bash

    # Install the software
    export DEBIAN_FRONTEND=noninteractive
    apt-get -y install nginx

----

Nginx configuration I
=======================

.. code:: bash

    rm /etc/nginx/sites-enabled/default
    cp /vagrant/resources/nginx/qgis-server \
        /etc/nginx/sites-enabled
    sed -i -e "s@QGIS_SERVER_DIR@${QGIS_SERVER_DIR}@" \
        /etc/nginx/sites-enabled/qgis-server

----

Nginx configuration II
=======================

.. code:: bash

    # Extract server name and port from HTTP_HOST, this 
    # is needed because we are behind a VMs mapped port

    map $http_host $parsed_server_name {
        default  $host;
        "~(?P<h>[^:]+):(?P<p>.*+)" $h;
    }

    map $http_host $parsed_server_port {
        default  $host;
        "~(?P<h>[^:]+):(?P<p>.*+)" $p;
    }

----

Nginx configuration III
=======================

Load balancing
(round robin default, or least_conn;)

.. code:: php

    upstream qgis_mapserv_backend {
        server unix:/run/qgis_mapserv4.sock;
        server unix:/run/qgis_mapserv3.sock;
        server unix:/run/qgis_mapserv2.sock;
        server unix:/run/qgis_mapserv1.sock;

    }

Note: sessions and persistence (ip-hash)!

----

Nginx configuration IV
=======================

.. code:: bash

    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # This is vital
        underscores_in_headers on;

        root /qgis-server/htdocs;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }

----

Nginx configuration V
=======================

.. code:: bash

        # Rewrite rule to shorten url + hide the project locations on disk
        # E.g. you can do a http://localhost:8080/qtb/helloworld?SERVICE=WMS.. instead of
        # http://localhost:8080/cgi-bin/qgis_mapserv.fcgi?MAP=/qgis-server/projects/helloworld.qgs&SERVICE=WMS..
        rewrite ^/qtb/(.*)$ /cgi-bin/qgis_mapserv.fcgi?map=/qgis-server/projects/$1.qgs last;

----

Nginx configuration VI
=======================

.. code:: bash

        location /cgi-bin/ { 
            # Disable gzip (it makes scripts feel slower since they 
            # have to complete before getting gzipped)
            gzip off;

            # Fastcgi socket
            fastcgi_pass  qgis_mapserv_backend;

            # $http_host contains the original server name and port, such as: "localhost:8080"
            # QGIS Server behind a VM needs this parsed values in order to automatically
            # get the correct values for the online resource URIs
            fastcgi_param SERVER_NAME       $parsed_server_name;
            fastcgi_param SERVER_PORT       $parsed_server_port;

            # Fastcgi parameters, include the standard ones 
            # (note: this needs to be last or it will overwrite fastcgi_param set above)
            include /etc/nginx/fastcgi_params;

        }
    }


----

Systemd configuration for FastCGI
===================================

Socket

.. code:: bash

    # Path: /etc/systemd/system/qgis-server-fcgi@.socket
    # systemctl enable qgis-server-fcgi@{1..4}.socket && systemctl start qgis-server-fcgi@{1..4}.socket

    [Unit]
    Description = QGIS Server FastCGI Socket (instance %i)
    
    [Socket]
    SocketUser = www-data
    SocketGroup = www-data
    SocketMode = 0660
    ListenStream = /run/qgis_mapserv%i.sock
    
    [Install]
    WantedBy = sockets.target

----


Systemd configuration for FastCGI 2
===================================

Service

.. code:: bash

    # Path: /etc/systemd/system/qgis-server-fcgi@.service
    # systemctl start qgis-server-fcgi@{1..4}.service

    [Unit]
    Description = QGIS Server Tracker FastCGI backend (instance %i)
    
    [Service]
    User = www-data
    Group = www-data
    ExecStart = /usr/lib/cgi-bin/qgis_mapserv.fcgi
    StandardInput = socket
    #StandardOutput = null
    #StandardError = null
    StandardOutput=syslog
    StandardError=syslog
    SyslogIdentifier=qgis-server-fcgi
    WorkingDirectory=/tmp

    Restart = always

   
----

Systemd configuration for FastCGI 3
===================================

Service

.. code:: bash
   
    # Environment
    Environment="QGIS_AUTH_DB_DIR_PATH=QGIS_SERVER_DIR/projects"
    Environment="QGIS_SERVER_LOG_FILE=QGIS_SERVER_DIR/logs/qgis-server-fcgi.log"
    Environment="QGIS_SERVER_LOG_LEVEL=0"
    Environment="QGIS_DEBUG=1"
    # Temporary workaround for #18230
    Environment="QGIS_PREFIX_PATH=/usr"
    Environment="DISPLAY=:99"
    Environment="QGIS_PLUGINPATH=QGIS_SERVER_DIR/plugins"
    Environment="QGIS_OPTIONS_PATH=QGIS_SERVER_DIR"
    Environment="QGIS_CUSTOM_CONFIG_PATH=QGIS_SERVER_DIR"

    [Install]
    WantedBy = multi-user.target

----

Checkpoint: Apache2
===========================

Check **WMS** on localhost 8081 in the browser

http://localhost:8081

Follow the links!


----

Checkpoint: Nginx
===========================

Check **WMS** on localhost 8080 in the browser

http://localhost:8080

Follow the links!

----

Checkpoint: QGIS as a Client
===================================

Check **WMS** and **WFS** using QGIS as a client.

Check that **WFS** requires a "username" and "password"

Check that **WWS** *GetFeatureInfo* returns a (blueish) formatted HTML

Note: a test project with pre-configured endpoints 
is available in the `resources/qgis/` directory.

----

Checkpoint: WMS search
=================================

Searching features with **WMS**

.. code::

    http://localhost:8080/qtb/helloworld?SERVICE=WMS
    &REQUEST=GetFeatureInfo&CRS=EPSG%3A4326&WIDTH=1794&HEIGHT=1194
    &LAYERS=world&QUERY_LAYERS=world&
    FILTER=world%3A%22NAME%22%20%3D%20%27SPAIN%27

The filter is a QGIS Expression:

**FILTER=world:"NAME" = 'SPAIN'**

* Field name is enclosed in double quotes, literal string in single quotes
* You need one space between the operator and tokens


----

Checkpoint: highlighting
=================================

The **SELECTION** parameter can highlight features from one or more layers:
Vector features can be selected by passing comma separated lists with feature ids in *GetMap* and *GetPrint*.
Example: *SELECTION=mylayer1:3,6,9;mylayer2:1,5,6*

.. code::

    http://localhost:8080/qtb/helloworld?SERVICE=WMS&VERSION=1.3.0&
    SELECTION=world%3A44&REQUEST=GetMap&FORMAT=image%2Fpng&TRANSPARENT=true&
    LAYERS=world&CRS=EPSG%3A4326&STYLES=&DPI=180&WIDTH=1794&HEIGHT=1194&
    BBOX=31.7944%2C-18.2153%2C58.0297%2C21.20361


----

Checkpoint: printing
==============================

From composer templates (with substitutions!)

.. code:: xml

  <Layouts>
    <Layout units="mm" printResolution="300" name="Printable World" 
    worldFileMap="{db75b0bf-f2f1-42e6-9727-1b6b21d8862e}">
    ...

FORMAT can be any of PDF, PNG
See also: DXF Export

----

Checkpoint: printing URL
==============================

.. code::

    http://localhost:8080/qtb/helloworld?SERVICE=WMS&VERSION=1.1.1&
    REQUEST=GetPrint&TEMPLATE=Printable%20World&CRS=EPSG%3A4326&
    map0:EXTENT=4,52,14,58&FORMAT=png&LAYERS=bluemarble,world

----

Checkpoint: printing substitutions
===================================

- Assign an *ID* to the label
- add *label_name=Your custom text*
- as an ID, choose a word that is not reserved in **WMS**

.. code::

    http://localhost:8080/qtb/helloworld?SERVICE=WMS&
    VERSION=1.1.1&REQUEST=GetPrint&TEMPLATE=Printable%20World
    &CRS=EPSG%3A4326&map0:EXTENT=4,52,14,58&FORMAT=png
    &LAYERS=bluemarble,world&print_title=Custom%20print%20title!

----

QGIS Server 2.x and python
============================

Since QGIS 2.8

.. code:: python

    from qgis.server import QgsServer   
    s = QgsServer()
    header, body = s.handleRequest(
        'MAP=/qgis-server/projects/helloworld.qgs' +
        '&SERVICE=WMS&REQUEST=GetCapabilities')
    print(header, body)

Full script:
https://github.com/qgis/QGIS/blob/release-2_18/tests/src/python/qgis_wrapped_server.py

----

QGIS Server 3.x and python
============================

Since QGIS 2.99

.. code:: python

    from qgis.core import QgsApplication
    from qgis.server import *
    qgs_app = QgsApplication([], False)
    qgs_server = QgsServer()
    request = QgsBufferServerRequest(
        'http://localhost:8081/?MAP=/qgis-server/projects/helloworld.qgs' +
        '&SERVICE=WMS&REQUEST=GetCapabilities')
    response = QgsBufferServerResponse()
    qgs_server.handleRequest(request, response)
    print(response.headers(), response.body())
    qgs_app.exitQgis()

Full script:
https://github.com/qgis/QGIS/blob/master/tests/src/python/qgis_wrapped_server.py

----

QGIS Server and python plugins
==================================

See presentation: http://www.itopen.it/bulk/nodebo/Presentations/Server%20Plugins/index.html

There are no substantial differences between plugins API in 2.x and 3.x

----

QGIS Server Access Control Plugins
==================================

Since QGIS 2.12

Fine-grained control over layers, features and attributes!

https://docs.qgis.org/testing/en/docs/pyqgis_developer_cookbook/server.html#access-control-plugin


Example: 
https://github.com/elpaso/qgis3-server-vagrant/blob/master/resources/web/plugins/accesscontrol/accesscontrol.py


----

QGIS Server 3.x and python services
===================================

Since QGIS 2.99

New server **plugin-based** architecture!

You can now create custom services in pure *Python*.

Example: https://github.com/elpaso/qgis3-server-vagrant/blob/master/resources/web/plugins/customservice/customservice.py

----

QGIS Server Python application 1
================================

Systemd

.. code:: bash

    # Listen on ports 809%i
    # Path: /etc/systemd/system/qgis-server-python@.service
    # systemctl start qgis-server-python@{1..4}.service


    [Unit]
    Description = QGIS Server Tracker Python backend (instance %i)
    
    [Service]
    User = www-data
    Group = www-data
    ExecStart = /qgis-server/qgis_wrapped_server_wsgi.py
    StandardInput = null
    #StandardOutput = null
    #StandardError = null
    StandardOutput=syslog
    StandardError=syslog
    SyslogIdentifier=qgis-server-python
    WorkingDirectory=/tmp

    Restart = always

----

QGIS Server Python application 2
================================

Systemd

.. code:: bash

    # Environment
    Environment=QGIS_SERVER_PORT=809%i
    Environment="QGIS_AUTH_DB_DIR_PATH=/qgis-server/projects"
    Environment="QGIS_SERVER_LOG_FILE=/qgis-server/logs/qgis-server-python.log"
    Environment="QGIS_SERVER_LOG_LEVEL=0"
    Environment="QGIS_DEBUG=1"
    # Temporary workaround for #18230
    Environment="QGIS_PREFIX_PATH=/usr"
    Environment="DISPLAY=:99"
    Environment="QGIS_PLUGINPATH=/qgis-server/plugins"
    Environment="QGIS_OPTIONS_PATH=/qgis-server"
    Environment="QGIS_CUSTOM_CONFIG_PATH=/qgis-server"

    [Install]
    WantedBy = multi-user.target

----

Caching
============================

A QGIS Server instance caches:

+ capabilities
+ projects

Caches are **not** shared among instances.

Layers are **not** cached.

Caching is generally delegated to different tier,
caching solutions are expecially recommended for serving
tiles:

+ mapproxy https://mapproxy.org/
+ tilecache http://tilecache.org/
+ tilestache http://tilestache.org/

Look for metatiles support if your layers contain labels.

----

Other examples
=====================

The Python QGIS tests contain a comprehensive set
of scripts to test all possible services of QGIS 
Server: 

https://github.com/qgis/QGIS/tree/master/tests/src/python

----

Authenticated layers in QGIS Server
===================================

QGIS authentication DB `qgis-auth.db` path can be specified with 
the environment variable `QGIS_AUTH_DB_DIR_PATH`

`QGIS_AUTH_PASSWORD_FILE` environment variable can contain the
master password required to decrypt the authentication DB.

Note: ensure to limit the file as only readable by the Server’s process user and to not store the file within web-accessible directories.

----

Parallel rendering
============================================


`QGIS_SERVER_PARALLEL_RENDERING`

Activates parallel rendering for WMS GetMap requests. It’s disabled (false) by default. Available values are:

0 or false (case insensitive)
1 or true (case insensitive)

`QGIS_SERVER_MAX_THREADS`

Number of threads to use when parallel rendering is activated. Default value is -1 to use the number of processor cores.


----

Logging
=======


`QGIS_SERVER_LOG_FILE`

Specify path and filename. Make sure that server has proper permissions for writing to file. File should be created automatically, just send some requests to server. If it’s not there, check permissions.


`QGIS_SERVER_LOG_LEVEL`

Specify desired log level. Available values are:

0 or `INFO` (log all requests)
1 or `WARNING`
2 or `CRITICAL` (log just critical errors, suitable for production purposes)


Release cycle
=============

LTR: 12 months support

https://www.qgis.org/en/site/getinvolved/development/roadmap.html#release-schedule
