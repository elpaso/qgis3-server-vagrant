# -*- coding: utf-8 -*-

"""
***************************************************************************
    ServerSimpleBrowseer.py
    ---------------------
    Date                 : August 2014
    Copyright            : (C) 2014-2015 by Alessandro Pasotti
    Email                : apasotti at gmail dot com
***************************************************************************
*                                                                         *
*   This program is free software; you can redistribute it and/or modify  *
*   it under the terms of the GNU General Public License as published by  *
*   the Free Software Foundation; either version 2 of the License, or     *
*   (at your option) any later version.                                   *
*                                                                         *
***************************************************************************
"""

__author__ = 'Alessandro Pasotti'
__date__ = 'March 2016'
__copyright__ = '(C) 2016, Alessandro Pasotti - ItOpen'

import sys
import os
import codecs
import re

# Import the PyQt and QGIS libraries
from qgis.PyQt.QtCore import *
from qgis.PyQt.QtGui import *
from qgis.core import *
from qgis.server import *


class ServerSimpleFilter(QgsServerFilter):

    def get_url(self, request, params):
        url = 'http://' if not self.serverInterface().getEnv("HTTPS") == 'on' else 'https://'
        server_name = self.serverInterface().getEnv("SERVER_NAME")
        if not server_name:
            server_name = self.serverInterface().requestHandler().requestHeader("HTTP_HOST")
        server_port = self.serverInterface().getEnv("SERVER_PORT")
        if not server_port:
            server_port = self.serverInterface().requestHandler().requestHeader("HTTP_PORT")
        url += server_name
        url += ':' + server_port
        script_name = self.serverInterface().getEnv("SCRIPT_NAME")
        if not script_name:
            script_name = self.serverInterface().requestHandler().requestHeader("HTTP_PATH_INFO")
        url += script_name
        url += '?MAP=' + params.get('MAP', '')
        return url


    def requestReady(self):
        request = self.serverInterface().requestHandler()
        params = request.parameterMap( )
        if params.get('SERVICE', '').lower() == 'wms' \
                and params.get('REQUEST', '').lower() == 'getmap' \
                and params.get('FORMAT', '').lower() == 'application/openlayers':
            QgsMessageLog.logMessage("OpenLayersFilter.requestReady FORMAT application/openlayers")
            request.setParameter('SERVICE', 'OPENLAYERS')


    def responseComplete(self):

        # TODO: error checking
        request = self.serverInterface().requestHandler()
        params = request.parameterMap( )

 
        if params.get('SERVICE', '').lower() == 'openlayers':
            request.clear()
            request.setResponseHeader('Content-type', 'text/html; charset=utf-8')
            minx, miny, maxx, maxy = params.get('BBOX', '0,0,0,0').split(',')
            url = self.get_url(request, params)
            QgsMessageLog.logMessage("OpenLayersFilter.responseComplete URL %s" % url, 'plugin')
            f = open(os.path.join(os.path.dirname(__file__), 'assets' , 'map_template.html'))
            body = ''.join(f.readlines())
            f.close()
            body = body % {
                'extent' : params.get('BBOX', ''),
                'url' : url,
                'layers': params.get('LAYERS', ''),
                'center': center,
                'zoom': params.get('ZOOM', '12'),
                'height': params.get('HEIGHT', 400),
                'width': params.get('WIDTH', 600),
                'projection' : params.get('CRS', 'EPSG:4326'),
            }
            request.appendBody(body.encode('utf8'))
            QgsMessageLog.logMessage("OpenLayersFilter.responseComplete BODY %s" % body, 'plugin')
            return


        if params.get('SERVICE', '').lower() == 'wms' \
                and params.get('REQUEST', '').lower() == 'xsl':
            request.clear()
            request.setResponseHeader('Content-type', 'text/xml; charset=utf-8')
            f = open(os.path.dirname(__file__) + '/assets/' + 'getprojectsettings.xsl')
            body = ''.join(f.readlines())
            f.close()
            request.appendBody(body.encode('utf8'))
            return


        if params.get('SERVICE', '').lower() == 'wms' \
                and params.get('REQUEST', '').lower() == 'getprojectsettings':
            # inject XSL code
            body = request.body()
            request.clearBody()
            url = self.get_url(request, params).encode('utf8')
            body = body.replace(b'<?xml version="1.0" encoding="utf-8"?>', b'<?xml version="1.0" encoding="utf-8"?>\n<?xml-stylesheet type="text/xsl" href="%s&amp;SERVICE=WMS&amp;REQUEST=XSL"?>' % url)
            request.appendBody(body)
            return


class ServerSimpleBrowser:
    """Plugin for QGIS server"""

    def __init__(self, serverIface):
        # Save reference to the QGIS server interface
        self.serverIface = serverIface
        try:
            self.serverIface.registerFilter(ServerSimpleFilter(serverIface), 1000)
        except Exception as e:
            QgsLogger.debug("ServerSimpleBrowser- Error loading filter %s", e)



class SimpleBrowser:
    def __init__(self, iface):
        # Save reference to the QGIS interface
        self.iface = iface
        self.canvas = iface.mapCanvas()


    def initGui(self):
        # Create action that will start plugin
        self.action = QAction(QIcon(":/plugins/"), "About Server SimpleBrowser", self.iface.mainWindow())
        # Add toolbar button and menu item
        self.iface.addPluginToMenu("Server SimpleBrowser", self.action)
        # connect the action to the run method
        QObject.connect(self.action, SIGNAL("activated()"), self.about)

    def unload(self):
        # Remove the plugin menu item and icon
        self.iface.removePluginMenu("Server SimpleBrowser", self.action)

    # run
    def about(self):
        QMessageBox.information(self.iface.mainWindow(), QCoreApplication.translate('SimpleBrowser', "Server SimpleBrowser"), QCoreApplication.translate('SimpleBrowser', "Server SimpleBrowser is a simple browser plugin for QGIS Server, it does just nothing in QGIS Desktop. See: <a href=\"http://www.itopen.it/qgis-server-simple-browser-plugin/\">plugin's homepage</a>"))



if __name__ == "__main__":
    pass
