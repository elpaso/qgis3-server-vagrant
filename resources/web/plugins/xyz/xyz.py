import os
import math
from qgis.server import *
from qgis.core import QgsMessageLog

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
        QgsMessageLog.logMessage('XYZ requestReady called!')
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


class XYZ:
    def __init__(self, serverIface):
        # Save reference to the QGIS server interface
        serverIface.registerFilter( XYZFilter(serverIface), 100 )
    
