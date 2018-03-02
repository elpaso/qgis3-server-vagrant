# -*- coding: utf-8 -*-
"""
 This script initializes the plugin, making it known to QGIS.
"""


def serverClassFactory(serverIface):
    from . getfeatureinfo import GetFeatureInfo
    return GetFeatureInfo(serverIface)
