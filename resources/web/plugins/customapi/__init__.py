# Custom API plugin example

def serverClassFactory(serverIface):
    from . customapi import CustomApi
    return CustomApi(serverIface)

