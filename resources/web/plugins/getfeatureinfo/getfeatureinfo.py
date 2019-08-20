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
