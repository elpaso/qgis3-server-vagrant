# -*- coding: utf-8 -*-
"""
 This script initializes the plugin, making it known to QGIS.
"""


def serverClassFactory(serverIface):
    from .ServerSimpleBrowser import ServerSimpleBrowser
    return ServerSimpleBrowser(serverIface)

def classFactory(iface):
    from .ServerSimpleBrowser import SimpleBrowser
    return SimpleBrowser(iface)

