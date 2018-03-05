import os

from qgis.server import *
from qgis.core import QgsMessageLog


class DebugFilter(QgsServerFilter):

    def requestReady(self):
        handler = self.serverInterface().requestHandler()
        params = handler.parameterMap( ) 
        if 'DEBUG' in params: 
            handler.setParameter('SERVICE', 'DEBUG')

    def responseComplete(self):
        handler = self.serverInterface().requestHandler()
        params = handler.parameterMap( )
        if params.get('SERVICE') != 'DEBUG':
            return
        
        headers_dict = handler.requestHeaders()
        handler.clear()
        handler.setResponseHeader('Status', '200 Ok')
        handler.appendBody(b'<h1>Params</h1>')
        for k in params:
            handler.appendBody(('<p><b>%s</b> %s</p>' % (k, params.get(k))).encode('utf8'))

        handler.appendBody('<h1>Headers</h1>'.encode('utf8'))
        for k in headers_dict:
            handler.appendBody(('<p><b>%s</b> %s</p>' % (k, headers_dict.get(k))).encode('utf8'))




class Debug:

    def __init__(self, serverIface):
        # Save reference to the QGIS server interface
        # Higher priority
        serverIface.registerFilter( DebugFilter(serverIface), 10 )
    
