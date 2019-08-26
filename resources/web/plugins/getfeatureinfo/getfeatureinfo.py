# coding=utf-8
""""Simple plugin example for GetFeatureInfo CSS injection

http://localhost:8080/cgi-bin/qgis_mapserv.fcgi?MAP=/qgis-server/projects/helloworld.qgs&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetFeatureInfo&FORMAT=image%2Fpng&TRANSPARENT=true&QUERY_LAYERS=world&LAYERS=world&INFO_FORMAT=text%2Fhtml&I=50&J=50&CRS=EPSG%3A4326&STYLES=&WIDTH=101&HEIGHT=101&BBOX=-16.101558208465576%2C-28.4765625%2C54.914066791534424%2C42.5390625

.. note:: This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

"""

__author__ = 'elpaso@itopen.it'
__date__ = '2019-08-26'
__copyright__ = 'Copyright 2019, ItOpen'


import os

from qgis.server import *

class GetFeatureInfoFilter(QgsServerFilter):

    def __init__(self, serverIface):
        super(GetFeatureInfoFilter, self).__init__(serverIface)

    def responseComplete(self):
        handler = self.serverInterface().requestHandler()
        params = handler.parameterMap( )
        if params.get('TEST', False):
            handler.clearBody()
            handler.appendBody(b"ciao")

        if (params.get('SERVICE', '').upper() == 'WMS' \
                and params.get('REQUEST', '').upper() == 'GETFEATUREINFO' \
                and params.get('INFO_FORMAT', '').upper() == 'TEXT/HTML' \
                and not handler.exceptionRaised() ):
            body = handler.body()
            body.replace(b'<BODY>', b"""<BODY><STYLE type="text/css">* {font-family: arial, sans-serif; color: #09095e;} table { border-collapse:collapse; } td, tr { border: solid 1px grey; }</STYLE>""")
            handler.clearBody()
            handler.appendBody(body)



class GetFeatureInfo:

    def __init__(self, serverIface):
        # Save reference to the QGIS server interface
        serverIface.registerFilter( GetFeatureInfoFilter(serverIface), 100 )
