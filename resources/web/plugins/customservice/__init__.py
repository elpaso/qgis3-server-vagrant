# Custom service plugin example

def serverClassFactory(serverIface):
    from . customservice import CustomService
    return CustomService(serverIface)

