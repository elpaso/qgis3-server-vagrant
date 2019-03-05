import os

from qgis.server import *

# ########## Load the custom expressions ##########
from qgis.utils import qgsfunction
from qgis.core import QgsExpression
from random import uniform

@qgsfunction(args='auto', group='QGIS Workshop')
def custom_qgis_function(value1, value2, feature, parent):
    return round(uniform(value1, value2), 2)


QgsExpression.registerFunction(custom_qgis_function)
# ########## Done loading custom expressions ##########


class LoadCustomExpressionsFilter(QgsServerFilter):

    def __init__(self, serverIface):
        super(LoadCustomExpressionsFilter, self).__init__(serverIface)


class LoadCustomExpressions:

    def __init__(self, serverIface):
        # Save reference to the QGIS server interface
        serverIface.registerFilter(LoadCustomExpressionsFilter(serverIface), 100)
