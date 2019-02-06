# -*- coding: utf-8 -*-
"""
 This script initializes the plugin, making it known to QGIS.
"""


def serverClassFactory(serverIface):
    from . loadcustomexpressions import LoadCustomExpressions
    return LoadCustomExpressions(serverIface)
