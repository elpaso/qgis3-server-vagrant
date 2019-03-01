# coding=utf-8
""""description

.. note:: This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

"""

__author__ = 'elpaso@itopen.it'
__date__ = '2019-02-28'
__copyright__ = 'Copyright 2019, ItOpen'


from qgis.server import QgsServerCacheFilter
from qgis.core import QgsMessageLog

from qgis.PyQt.QtCore import QByteArray
import hashlib


class StupidCache(QgsServerCacheFilter):
    """A simple in-memory and not-shared cache for demonstration purposes"""

    _cache = {}

    def _get_hash(self, request):
        paramMap = request.parameters()
        urlParam = "&".join(["%s=%s" % (k, paramMap[k]) for k in paramMap.keys()])
        m = hashlib.md5()
        m.update(urlParam.encode('utf8'))
        return m.hexdigest()

    def getCachedDocument(self, project, request, key):
        QgsMessageLog.logMessage('getCachedDocument has %s cached documents' % len(self._cache))
        QgsMessageLog.logMessage('getCachedDocument keys: %s' % self._cache.keys())
        if 'CLEAR_CACHE' in request.parameters().keys():
            QgsMessageLog.logMessage('Cache cleared')
            self._cache = {}
        hash = self._get_hash(request)
        try:
            result = self._cache[self._get_hash(request)]
            QgsMessageLog.logMessage('Returning cached document %s' % hash)
            return result
        except KeyError:
            QgsMessageLog.logMessage('No cached document %s' % hash)
            return QByteArray()

    def setCachedDocument(self, doc, project, request, key):
        hash = self._get_hash(request)
        QgsMessageLog.logMessage('Cached document added %s' % hash)
        self._cache[hash] = doc
        return True


class DummyCache:
    """Cache plugin: this gets loaded by the server at start and
    creates the cache filter.
    """

    def __init__(self, serverIface):
        """Register the cache"""

        serverIface.registerServerCache(StupidCache(serverIface), 100 )

