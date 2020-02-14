import os

from qgis.server import *
from qgis.core import QgsMessageLog
import base64


class RestrictedAccessControl(QgsAccessControlFilter):

    """ Used to have restriction access """

    # Be able to deactivate the access control to have a reference point
    _active = True

    def __init__(self, server_iface):
        super(QgsAccessControlFilter, self).__init__(server_iface)

    def layerFilterExpression(self, layer):
        """ Return an additional expression filter """

        QgsMessageLog.logMessage("Accesscontrol name %s" % layer.name())
        QgsMessageLog.logMessage("Accesscontrol shortName %s" % layer.shortName())

        if not self._active:
            return super(RestrictedAccessControl, self).layerFilterExpression(layer)

        return "\"ISO2\" = 'IT'" if layer.shortName() == "restricted" else None

    def layerFilterSubsetString(self, layer):
        """ Return an additional subset string (typically SQL) filter """

        if not self._active:
            return super(RestrictedAccessControl, self).layerFilterSubsetString(layer)

        if layer.shortName() == "restricted":
            return "\"ISO2\" = 'IT'"
        else:
            return None

    def layerPermissions(self, layer):
        """ Return the layer rights """

        if not self._active:
            return super(RestrictedAccessControl, self).layerPermissions(layer)

        rh = self.serverInterface().requestHandler()
        rights = QgsAccessControlFilter.LayerPermissions()
        # Used to test WFS transactions
        if rh.parameter("LAYER_PERM") == "no" and rh.parameterMap()["LAYER_PERM"] == "no":
            return rights
        # Used to test the WCS
        if rh.parameter("TEST") == "dem" and rh.parameterMap()["TEST"] == "dem":
            rights.canRead = layer.shortName() != "dem"
        else:
            rights.canRead = layer.shortName() != "Country"
        if layer.name() == "db_point":
            rights.canRead = rights.canInsert = rights.canUpdate = rights.canDelete = True

        return rights

    def authorizedLayerAttributes(self, layer, attributes):
        """ Return the authorised layer attributes """

        if not self._active:
            return super(RestrictedAccessControl, self).authorizedLayerAttributes(layer, attributes)

        if "ISO1" in attributes:  # spellok
            attributes.remove("ISO1")  # spellok
        return attributes

    def allowToEdit(self, layer, feature):
        """ Are we authorise to modify the following geometry """

        if not self._active:
            return super(RestrictedAccessControl, self).allowToEdit(layer, feature)

        return feature.attribute("ISO2") in ["IT", "CH"]

    def cacheKey(self):
        """Cache key to used to create the capabilities cache, "" for no cache"""

        return "r" if self._active else "f"




class AccessControl:

    def __init__(self, serverIface):
        # Save reference to the QGIS server interface
        serverIface.registerAccessControl( RestrictedAccessControl(serverIface), 100 )

