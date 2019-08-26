
# coding=utf-8
"""" Simple SERVICE custom implementation

http://localhost:8080/cgi-bin/qgis_mapserv.cgi?MAP=/qgis-server/projects/helloworld.qgs&SERVICE=CUSTOM

.. note:: This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

"""

__author__ = 'elpaso@itopen.it'
__date__ = '2019-08-26'
__copyright__ = 'Copyright 2019, ItOpen'


from qgis.PyQt.QtCore import QBuffer, QIODevice, QTextStream
from qgis.server import (QgsServiceRegistry,
                         QgsService, QgsServerFilter)
from qgis.core import QgsMessageLog

class CustomServiceService(QgsService):

    def __init__(self):
        QgsService.__init__(self)

    def name(self):
        return "CUSTOM"

    def version(self):
        return "1.0.0"

    def allowMethod(method):
        return True

    def executeRequest(self, request, response, project):
        response.setStatusCode(200)
        QgsMessageLog.logMessage('Custom service executeRequest')
        response.write("Custom service executeRequest")


class CustomService():

    def __init__(self, serverIface):
        self.serv = CustomServiceService()
        serverIface.serviceRegistry().registerService(CustomServiceService())

