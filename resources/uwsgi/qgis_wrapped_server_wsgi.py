#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
QGIS Server HTTP wrapper

This script launches a QGIS Server listening on port 8081 or on the port
specified on the environment variable QGIS_SERVER_PORT.
QGIS_SERVER_HOST (defaults to 127.0.0.1)

A XYZ map service is also available for multithreading testing:

  ?MAP=/path/to/projects.qgs&SERVICE=XYZ&X=1&Y=0&Z=1&LAYERS=world


For testing purposes, HTTP Basic can be enabled by setting the following
environment variables:

  * QGIS_SERVER_HTTP_BASIC_AUTH (default not set, set to anything to enable)
  * QGIS_SERVER_USERNAME (default ="username")
  * QGIS_SERVER_PASSWORD (default ="password")

.. note:: This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
"""

__author__ = 'Alessandro Pasotti'
__date__ = '05/15/2016'
__copyright__ = 'Copyright 2016, The QGIS Project'
# This will get replaced with a git SHA1 when you do a git archive
__revision__ = '$Format:%H$'


import os

from wsgiref.simple_server import make_server
from cgi import parse_qs, escape

# Needed on Qt 5 so that the serialization of XML is consistent among all executions
os.environ['QT_HASH_SEED'] = '1'

import sys
import signal
import ssl
import math
import urllib.parse
from http.server import BaseHTTPRequestHandler, HTTPServer
from socketserver import ThreadingMixIn
import threading

from qgis.core import QgsApplication, QgsCoordinateTransform, QgsCoordinateReferenceSystem, QgsMessageLog
from qgis.server import QgsServer, QgsServerRequest, QgsBufferServerRequest, QgsBufferServerResponse, QgsServerFilter

QGIS_SERVER_PORT = int(os.environ.get('QGIS_SERVER_PORT', '8081'))
QGIS_SERVER_HOST = os.environ.get('QGIS_SERVER_HOST', '127.0.0.1')
# PKI authentication
QGIS_SERVER_PKI_CERTIFICATE = os.environ.get('QGIS_SERVER_PKI_CERTIFICATE')
QGIS_SERVER_PKI_KEY = os.environ.get('QGIS_SERVER_PKI_KEY')
QGIS_SERVER_PKI_AUTHORITY = os.environ.get('QGIS_SERVER_PKI_AUTHORITY')
QGIS_SERVER_PKI_USERNAME = os.environ.get('QGIS_SERVER_PKI_USERNAME')

# Check if PKI - https is enabled
https = (QGIS_SERVER_PKI_CERTIFICATE is not None and
         os.path.isfile(QGIS_SERVER_PKI_CERTIFICATE) and
         QGIS_SERVER_PKI_KEY is not None and
         os.path.isfile(QGIS_SERVER_PKI_KEY) and
         QGIS_SERVER_PKI_AUTHORITY is not None and
         os.path.isfile(QGIS_SERVER_PKI_AUTHORITY) and
         QGIS_SERVER_PKI_USERNAME)


qgs_app = QgsApplication([], False)
qgs_server = QgsServer()


if os.environ.get('QGIS_SERVER_HTTP_BASIC_AUTH') is not None:
    import base64

    class HTTPBasicFilter(QgsServerFilter):

        def requestReady(self):
            handler = self.serverInterface().requestHandler()
            auth = self.serverInterface().requestHandler().requestHeader('HTTP_AUTHORIZATION')
            if auth:
                username, password = base64.b64decode(auth[6:]).split(b':')
                if (username.decode('utf-8') == os.environ.get('QGIS_SERVER_USERNAME', 'username') and
                        password.decode('utf-8') == os.environ.get('QGIS_SERVER_PASSWORD', 'password')):
                    return
            handler.setParameter('SERVICE', 'ACCESS_DENIED')

        def responseComplete(self):
            handler = self.serverInterface().requestHandler()
            auth = self.serverInterface().requestHandler().requestHeader('HTTP_AUTHORIZATION')
            if auth:
                username, password = base64.b64decode(auth[6:]).split(b':')
                if (username.decode('utf-8') == os.environ.get('QGIS_SERVER_USERNAME', 'username') and
                        password.decode('utf-8') == os.environ.get('QGIS_SERVER_PASSWORD', 'password')):
                    return
            # No auth ...
            handler.clear()
            handler.setResponseHeader('Status', '401 Authorization required')
            handler.setResponseHeader('WWW-Authenticate', 'Basic realm="QGIS Server"')
            handler.appendBody(b'<h1>Authorization required</h1>')

    filter = HTTPBasicFilter(qgs_server.serverInterface())
    qgs_server.serverInterface().registerFilter(filter)


def num2deg(xtile, ytile, zoom):
    """This returns the NW-corner of the square. Use the function with xtile+1 and/or ytile+1 
    to get the other corners. With xtile+0.5 & ytile+0.5 it will return the center of the tile."""
    n = 2.0 ** zoom
    lon_deg = xtile / n * 360.0 - 180.0
    lat_rad = math.atan(math.sinh(math.pi * (1 - 2 * ytile / n)))
    lat_deg = math.degrees(lat_rad)
    return (lat_deg, lon_deg)


class XYZFilter(QgsServerFilter):
    """XYZ server, example: ?MAP=/path/to/projects.qgs&SERVICE=XYZ&X=1&Y=0&Z=1&LAYERS=world"""

    def requestReady(self):
        handler = self.serverInterface().requestHandler()
        if handler.parameter('SERVICE') == 'XYZ':
            x = int(handler.parameter('X'))
            y = int(handler.parameter('Y'))
            z = int(handler.parameter('Z'))
            # NW corner
            lat_deg, lon_deg = num2deg(x, y, z)
            # SE corner
            lat_deg2, lon_deg2 = num2deg(x + 1, y + 1, z)
            handler.setParameter('SERVICE', 'WMS')
            handler.setParameter('REQUEST', 'GetMap')
            handler.setParameter('VERSION', '1.3.0')
            handler.setParameter('SRS', 'EPSG:4326')
            handler.setParameter('HEIGHT', '256')
            handler.setParameter('WIDTH', '256')
            handler.setParameter('BBOX', "{},{},{},{}".format(lat_deg2, lon_deg, lat_deg, lon_deg2))


xyzfilter = XYZFilter(qgs_server.serverInterface())
qgs_server.serverInterface().registerFilter(xyzfilter)



class application(object):
    """QGIS Server WSGI application"""

    def __init__(self, environ, start_fn):
        self.environ = environ
        self.start_fn = start_fn

    def __iter__(self):
        if self.environ['REQUEST_METHOD'] == 'POST':
            yield self.do_POST()
        else:
            yield self.do_GET()

    def do_GET(self, post_body=None):
        # CGI vars:
        headers = {}        
        for k, v in self.environ.copy().items():
            headers['%s%s' % ('HTTP_' if not k.startswith('HTTP_') else '', k.replace(' ', '-').replace('-', '_').replace(' ', '-').upper())] = str(v)
        path = self.environ.get('PATH_INFO', '/')
        if not path.startswith('http'):
            path = "%s://%s:%s%s?%s" % (self.environ.get('wsgi.url_scheme'), headers.get('HTTP_HOST'), headers.get('HTTP_PORT'), path, self.environ.get('QUERY_STRING'))
        request = QgsBufferServerRequest(path, (QgsServerRequest.PostMethod if post_body is not None else QgsServerRequest.GetMethod), headers, post_body)
        response = QgsBufferServerResponse()
        QgsMessageLog.logMessage('Here 1!')
        qgs_server.handleRequest(request, response)
        QgsMessageLog.logMessage('Here!')


        headers_dict = response.headers()
        response_headers = [(k, v) for k, v in headers_dict.items()]
        try:
            self.start_fn(headers_dict['Status'], response_headers)
        except:
            self.start_fn('200 OK',response_headers)
        return bytes(response.body())

    def do_POST(self):
        content_len = int(self.headers.get('content-length', 0))
        post_env = self.environ.copy()
        post_env['QUERY_STRING'] = ''
        post_body = cgi.FieldStorage(
            fp= self.environ['wsgi.input'],
            environ=post_env,
            keep_blank_values=True
        )
        return self.do_GET(post_body)


if __name__ == '__main__':
    from wsgiref.simple_server import make_server
    server = make_server(QGIS_SERVER_HOST, QGIS_SERVER_PORT, application)
    print('Starting server on %s://%s:%s, use <Ctrl-C> to stop' %
          ('http', QGIS_SERVER_HOST, QGIS_SERVER_PORT), flush=True)

    def signal_handler(signal, frame):
        global qgs_app
        print("\nExiting QGIS...")
        qgs_app.exitQgis()
        sys.exit(0)

    server.serve_forever()
