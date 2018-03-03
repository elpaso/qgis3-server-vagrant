#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
QGIS Server HTTP Wsgi wrapper

This script launches a QGIS Server listening on port 8081 or on the port
specified on the environment variable QGIS_SERVER_PORT.
QGIS_SERVER_HOST (defaults to 127.0.0.1)

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

import importlib
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


qgs_app = QgsApplication([], False)
qgs_server = QgsServer()


# Load plugins
if os.environ.get('QGIS_PLUGINPATH', False):
    plugindir = os.environ.get('QGIS_PLUGINPATH')
    sys.path.append(plugindir)
    # Magic mistery: without this, virtual QgsServerFilter instances are not wrapped
    iface = qgs_server.serverInterface()
    try:
        for modulename in [(a, b, c) for a, b, c in os.walk(plugindir)][0][1]:
            try:
                module = importlib.import_module(modulename)
                getattr(module, 'serverClassFactory')(iface)
                QgsMessageLog.logMessage('Python plugin %s loaded!' % modulename)
            except:
                QgsMessageLog.logMessage('Could not load Python plugin %s!' % modulename)
    except:
        QgsMessageLog.logMessage('No plugins found in %s!' % plugindir)



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
        qgs_server.handleRequest(request, response)


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
