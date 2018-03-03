
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

