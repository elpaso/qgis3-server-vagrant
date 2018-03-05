<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

    xmlns:wms="http://www.opengis.net/wms"
    xmlns:sld="http://www.opengis.net/sld"
    xmlns:qgs="http://www.qgis.org/wms"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"

    xsi:schemaLocation="http://www.opengis.net/wms http://schemas.opengis.net/wms/1.3.0/capabilities_1_3_0.xsd
    http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/sld_capabilities.xsd
    http://www.qgis.org/wms http://qwc/cgi-bin/qgis_mapserv.fcgi?map=/home/ale/public_html/asti/QGIS-Web-Client/site/projects/asti/asti.qgs&amp;SERVICE=WMS&amp;REQUEST=GetSchemaExtension"

    >
    <xsl:output
        method="html"
        indent="yes"
        encoding="UTF-8"
    />


<xsl:template match="/wms:WMS_Capabilities">
<html lang="en">
  <head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>QGIS Server Explorer</title>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous"/>
    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous"/>
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <style type="text/css">
        .table > tbody > tr > td.level1 {
            padding-left: 1em;
        }
        .table > tbody > tr > td.level2 {
            padding-left: 2em;
        }
        .table > tbody > tr > td.level3 {
            padding-left: 3em;
        }
        .table > tbody > tr > td.level4 {
            padding-left: 4em;
        }

    .qgis-logo {
	background-image: url(data:image/svg+xml;base64,PHN2ZyB4bWxuczpzdmc9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iNTkuMyIgaGVpZ2h0PSI2NS40IiBpZD0ic3ZnNDkwNyIgdmVyc2lvbj0iMS4xIj48c3R5bGU+LnMwe3N0b3AtY29sb3I6IzBkNDEwMDtzdG9wLW9wYWNpdHk6MTt9LnMxe3N0b3AtY29sb3I6IzEyOTMwMDtzdG9wLW9wYWNpdHk6MTt9LnMye3N0b3AtY29sb3I6IzBkMWQwMDtzdG9wLW9wYWNpdHk6MTt9LnMze3N0b3AtY29sb3I6IzBkNzIwMDtzdG9wLW9wYWNpdHk6MTt9LnM0e2ZpbGw6I2U0ZjM2Mzt9LnM1e2NvbG9yLWludGVycG9sYXRpb24tZmlsdGVyczpzUkdCO308L3N0eWxlPjxkZWZzIGlkPSJkZWZzNDkwOSI+PGNsaXBQYXRoIGNsaXBQYXRoVW5pdHM9InVzZXJTcGFjZU9uVXNlIiBpZD0iY2xpcFBhdGg0MTQ0Ij48cmVjdCBpZD0icmVjdDQxNDYiIHdpZHRoPSI0Mi45IiBoZWlnaHQ9IjM5LjYiIHg9IjU2NS4yIiB5PSI2NDYuMiIgdHJhbnNmb3JtPSJtYXRyaXgoMC45OTk5MDA5NiwtMC4wMTQwNzM4OCwwLjAxNDA3Mzg4LDAuOTk5OTAwOTYsMCwwKSIgZmlsbD0iIzAwMCIvPjwvY2xpcFBhdGg+PGxpbmVhckdyYWRpZW50IHhsaW5rOmhyZWY9IiNsaW5lYXJHcmFkaWVudDUzNDItNC05LTciIGlkPSJsaW5lYXJHcmFkaWVudDM5NzAtNiIgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiIGdyYWRpZW50VHJhbnNmb3JtPSJ0cmFuc2xhdGUoMTU2LjA4NzY1LDIwOC45NDQwNykiIHgxPSI0MTMuNCIgeTE9IjQ3Ny42IiB4Mj0iNDIzLjYiIHkyPSI0NjMuOCIvPjxsaW5lYXJHcmFkaWVudCBpZD0ibGluZWFyR3JhZGllbnQ1MzQyLTQtOS03Ij48c3RvcCBvZmZzZXQ9IjAiIGlkPSJzdG9wNTM0NC0wLTAtNiIgY2xhc3M9InMwIi8+PHN0b3Agb2Zmc2V0PSIxIiBpZD0ic3RvcDUzNDYtODUtOS0wIiBjbGFzcz0iczEiLz48L2xpbmVhckdyYWRpZW50PjxsaW5lYXJHcmFkaWVudCB5Mj0iNDYzLjgiIHgyPSI0MjMuNiIgeTE9IjQ3Ny42IiB4MT0iNDEzLjQiIGdyYWRpZW50VHJhbnNmb3JtPSJtYXRyaXgoLTAuMjgyNjgwNzQsLTAuOTU5MjE0MDYsLTAuOTU5MjE0MDYsMC4yODI2ODA3NCwxMTQ0Ljc0MjQsOTQ4LjMwMjI3KSIgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiIGlkPSJsaW5lYXJHcmFkaWVudDQxMTEiIHhsaW5rOmhyZWY9IiNsaW5lYXJHcmFkaWVudDUzNDItNC0wLTQiLz48bGluZWFyR3JhZGllbnQgaWQ9ImxpbmVhckdyYWRpZW50NTM0Mi00LTAtNCI+PHN0b3Agb2Zmc2V0PSIwIiBpZD0ic3RvcDUzNDQtMC05LTciIGNsYXNzPSJzMiIvPjxzdG9wIG9mZnNldD0iMSIgaWQ9InN0b3A1MzQ2LTg1LTUtMyIgY2xhc3M9InMzIi8+PC9saW5lYXJHcmFkaWVudD48Y2xpcFBhdGggY2xpcFBhdGhVbml0cz0idXNlclNwYWNlT25Vc2UiIGlkPSJjbGlwUGF0aDQ4MjUtOCI+PHBhdGggZD0ibTQ4NS4xIDQ0Ni44Yy05LjggMC41LTE3LjYgOS0xNy42IDE5LjMgMCAxMC43IDguMyAxOS4zIDE4LjUgMTkuMyAxLjEgMCAyLjItMC4xIDMuMi0wLjNsMCAzLjFjMC4xIDEuMyAxLjcgNC4xIDYuNyA0LjIgNS44IDAgOC40LTMuNSA4LjktNC42IDAuOS0yLjQgMC43LTQgMC43LTUgMCAwLjYtMiA0LjEtNS4xIDQuMi01IDAuMi00LjQtMC43LTQuNC0ybDAtMi42YzUuMS0zLjQgOC41LTkuNCA4LjUtMTYuMyAwLTEwLjctOC4zLTE5LjMtMTguNS0xOS4zQzQ4NS43IDQ0Ni44IDQ4NS40IDQ0Ni44IDQ4NS4xIDQ0Ni44em0wLjYgMS40YzMuOSAwIDcgNy45IDcgMTcuNiAwIDIuMi0wLjIgNC4yLTAuNCA2LjItMS42LTAuNy0zLjctMS4yLTYuMi0xLjItMy43IDAtNiAwLjktNi45IDEuNS0wLjMtMi0wLjUtNC4yLTAuNS02LjRDNDc4LjcgNDU2IDQ4MS44IDQ0OC4yIDQ4NS43IDQ0OC4yem0tMS4zIDIzLjVjMy43IDAuMSA0LjggMS41IDQuOCAyLjNsMCA3LjFjLTEgMS41LTIuMiAyLjQtMy41IDIuNC0yLjggMC01LjItNC4yLTYuMy0xMC4yQzQ4MC4yIDQ3Mi41IDQ4MiA0NzEuNiA0ODQuNCA0NzEuNloiIGlkPSJwYXRoNDgyNy01IiBmaWxsPSIjZTRmMzYzIi8+PC9jbGlwUGF0aD48ZmlsdGVyIGlkPSJmaWx0ZXI0Nzc2LTUiIHg9Ii0wLjMiIHdpZHRoPSIxLjciIHk9Ii0wLjQiIGhlaWdodD0iMS44IiBjb2xvci1pbnRlcnBvbGF0aW9uLWZpbHRlcnM9InNSR0IiPjxmZUdhdXNzaWFuQmx1ciBzdGREZXZpYXRpb249IjAuNyIgaWQ9ImZlR2F1c3NpYW5CbHVyNDc3OC0wIi8+PC9maWx0ZXI+PGZpbHRlciBpZD0iZmlsdGVyNDk0Ny04LTQiIGNvbG9yLWludGVycG9sYXRpb24tZmlsdGVycz0ic1JHQiI+PGZlR2F1c3NpYW5CbHVyIHN0ZERldmlhdGlvbj0iMSIgaWQ9ImZlR2F1c3NpYW5CbHVyNDk0OS0wLTUiLz48L2ZpbHRlcj48bGluZWFyR3JhZGllbnQgeGxpbms6aHJlZj0iI2xpbmVhckdyYWRpZW50NTM0Mi00LTkiIGlkPSJsaW5lYXJHcmFkaWVudDM5NzAiIGdyYWRpZW50VW5pdHM9InVzZXJTcGFjZU9uVXNlIiBncmFkaWVudFRyYW5zZm9ybT0idHJhbnNsYXRlKDE1Ni4wODc2NSwyMDguOTQ0MDcpIiB4MT0iNDEzLjQiIHkxPSI0NzcuNiIgeDI9IjQyMy42IiB5Mj0iNDYzLjgiLz48bGluZWFyR3JhZGllbnQgaWQ9ImxpbmVhckdyYWRpZW50NTM0Mi00LTkiPjxzdG9wIG9mZnNldD0iMCIgaWQ9InN0b3A1MzQ0LTAtMCIgY2xhc3M9InMwIi8+PHN0b3Agb2Zmc2V0PSIxIiBpZD0ic3RvcDUzNDYtODUtOSIgY2xhc3M9InMxIi8+PC9saW5lYXJHcmFkaWVudD48bGluZWFyR3JhZGllbnQgeGxpbms6aHJlZj0iI2xpbmVhckdyYWRpZW50NTM0Mi00LTAtNCIgaWQ9ImxpbmVhckdyYWRpZW50Mzk3MiIgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiIGdyYWRpZW50VHJhbnNmb3JtPSJtYXRyaXgoLTAuMjgyNjgwNzQsLTAuOTU5MjE0MDYsLTAuOTU5MjE0MDYsMC4yODI2ODA3NCwxMTQ0Ljc0MjQsOTQ4LjMwMjI3KSIgeDE9IjQxMy40IiB5MT0iNDc3LjYiIHgyPSI0MjMuNiIgeTI9IjQ2My44Ii8+PGxpbmVhckdyYWRpZW50IGlkPSJsaW5lYXJHcmFkaWVudDQ4ODciPjxzdG9wIG9mZnNldD0iMCIgaWQ9InN0b3A0ODg5IiBjbGFzcz0iczIiLz48c3RvcCBvZmZzZXQ9IjEiIGlkPSJzdG9wNDg5MSIgY2xhc3M9InMzIi8+PC9saW5lYXJHcmFkaWVudD48ZmlsdGVyIGlkPSJmaWx0ZXI1NDI3LTItNSIgY29sb3ItaW50ZXJwb2xhdGlvbi1maWx0ZXJzPSJzUkdCIj48ZmVHYXVzc2lhbkJsdXIgc3RkRGV2aWF0aW9uPSIwLjUiIGlkPSJmZUdhdXNzaWFuQmx1cjU0MjktMi04Ii8+PC9maWx0ZXI+PC9kZWZzPjxtZXRhZGF0YSBpZD0ibWV0YWRhdGE0OTEyIi8+PGcgaWQ9ImxheWVyMSIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTI5My4yMjQwMiwtNDUxLjExMTE2KSI+PHBhdGggZD0ibTQ0NS41IDQ0My42LTEzLjQgNS41IDMuNSAyLjNjMCAwLTIxLjcgMjUuMi0yNi43IDMxLjFsLTkuNCAzLjQgNy45IDIgMi4yIDcuNCAyLjgtOS40IDI2LjgtMzEuMiAzIDMuM0w0NDUuNSA0NDMuNloiIGlkPSJwYXRoMzg5NS02LTYtNy00LTYtMi03LTUiIHRyYW5zZm9ybT0ibWF0cml4KDAuOTk5NTg0MzksLTAuMDI4ODI3OTQsMC4wMjg4Mjc5NCwwLjk5OTU4NDM5LC0xMTIuOTQ4ODYsMjYuNDUxNzIyKSIgc3R5bGU9ImZpbGw6IzAwMDtmaWx0ZXI6dXJsKCNmaWx0ZXI1NDI3LTItNSk7b3BhY2l0eTowO3N0cm9rZS13aWR0aDoxO3N0cm9rZTojMDYwMDAwIi8+PGcgaWQ9ImczOTY2IiB0cmFuc2Zvcm09Im1hdHJpeCgwLjk5OTkwMDk2LDAuMDE0MDczODgsLTAuMDE0MDczODgsMC45OTk5MDA5NiwtMjQ1LjEwMTU3LC0yMDEuNzAwMjgpIj48cGF0aCBpZD0icGF0aDM4OTUtNi02LTctNC02LTgtNCIgZD0ibTU5Ny43IDY0OS4xLTEyLjkgNi4zIDMuNyAyLjFjMCAwLTIwIDI2LjYtMjQuNSAzMi44bC05LjEgNCA4IDEuNEw1OTcuNyA2NDkuMVoiIGZpbGw9InVybCgjbGluZWFyR3JhZGllbnQzOTcwKSIvPjxwYXRoIGlkPSJwYXRoMzg5NS02LTYtNy00LTYtOC00LTUiIGQ9Im01OTcuNyA2NDkuMS0yLjQgMTQuMi0zLjEtMi45YzAgMC0xOS45IDI2LjctMjQuNiAzMi44bC0xLjMgOS45LTMuNi03LjNMNTk3LjcgNjQ5LjFaIiBmaWxsPSJ1cmwoI2xpbmVhckdyYWRpZW50Mzk3MikiLz48L2c+PHBhdGggZD0ibTMyMi4xIDQ2NGMtOS44IDAuNS0xNy42IDktMTcuNiAxOS4zIDAgMTAuNyA4LjMgMTkuMyAxOC41IDE5LjMgMS4xIDAgMi4yLTAuMSAzLjItMC4zbDAgMy4xYzAuMSAxLjMgMS43IDQuMSA2LjcgNC4yIDUuOCAwIDguNC0zLjUgOC45LTQuNiAwLjktMi40IDAuNy00IDAuNy01IDAgMC42LTIgNC4xLTUuMSA0LjItNSAwLjItNC40LTAuNy00LjQtMmwwLTIuNmM1LjEtMy40IDguNS05LjQgOC41LTE2LjMgMC0xMC43LTguMy0xOS4zLTE4LjUtMTkuM0MzMjIuOCA0NjQgMzIyLjUgNDY0IDMyMi4xIDQ2NHptMC42IDEuNGMzLjkgMCA3IDcuOSA3IDE3LjYgMCAyLjItMC4yIDQuMi0wLjQgNi4yLTEuNi0wLjctMy43LTEuMi02LjItMS4yLTMuNyAwLTYgMC45LTYuOSAxLjUtMC4zLTItMC41LTQuMi0wLjUtNi40QzMxNS44IDQ3My4yIDMxOC45IDQ2NS40IDMyMi44IDQ2NS40em0tMS4zIDIzLjVjMy43IDAuMSA0LjggMS41IDQuOCAyLjNsMCA3LjFjLTEgMS41LTIuMiAyLjQtMy41IDIuNC0yLjggMC01LjItNC4yLTYuMy0xMC4yQzMxNy4zIDQ4OS43IDMxOS4xIDQ4OC44IDMyMS41IDQ4OC44WiIgaWQ9InBhdGgzMDUwLTMtOS0zLTQtMi00IiBzdHlsZT0iZmlsbDojMDAwO2ZpbHRlcjp1cmwoI2ZpbHRlcjQ5NDctOC00KSIvPjxwYXRoIGQ9Im0zMjEuNiA0NjMuNWMtOS44IDAuNS0xNy42IDktMTcuNiAxOS4zIDAgMTAuNyA4LjMgMTkuMyAxOC41IDE5LjMgMS4xIDAgMi4yLTAuMSAzLjItMC4zbDAgMy4xYzAuMSAxLjMgMS43IDQuMSA2LjcgNC4yIDUuOCAwIDguNC0zLjUgOC45LTQuNiAwLjktMi40IDAuNy00IDAuNy01IDAgMC42LTIgNC4xLTUuMSA0LjItNSAwLjItNC40LTAuNy00LjQtMmwwLTIuNmM1LjEtMy40IDguNS05LjQgOC41LTE2LjMgMC0xMC43LTguMy0xOS4zLTE4LjUtMTkuM0MzMjIuMiA0NjMuNSAzMjEuOSA0NjMuNSAzMjEuNiA0NjMuNXptMC42IDEuNGMzLjkgMCA3IDcuOSA3IDE3LjYgMCAyLjItMC4yIDQuMi0wLjQgNi4yLTEuNi0wLjctMy43LTEuMi02LjItMS4yLTMuNyAwLTYgMC45LTYuOSAxLjUtMC4zLTItMC41LTQuMi0wLjUtNi40QzMxNS4yIDQ3Mi43IDMxOC40IDQ2NC44IDMyMi4yIDQ2NC44em0tMS4zIDIzLjVjMy43IDAuMSA0LjggMS41IDQuOCAyLjNsMCA3LjFjLTEgMS41LTIuMiAyLjQtMy41IDIuNC0yLjggMC01LjItNC4yLTYuMy0xMC4yQzMxNi44IDQ4OS4yIDMxOC42IDQ4OC4zIDMyMSA0ODguM1oiIGlkPSJwYXRoMzA1MC0zLTktMy0yLTMiIGZpbGw9IiNlNGYzNjMiLz48cGF0aCBpZD0icGF0aDQ3MzgtNSIgZD0ibTQ4OC40IDQ0OC45YzAgMCAzIDAuNSA0LjIgMS4yIDEuMSAwLjcgMC4yIDIuNyAwLjIgMi43TDQ5MC42IDQ1Mi45Wk00NzkuNSA0NzIuMWMwIDAgMi40LTEuMiA0LTEuNCAxLjYtMC4yIDQuNC0wLjIgNS42IDAuMSAxLjEgMC4zIDMuMyAwLjkgMy41IDEuMyAwLjIgMC4zIDEgMy4zIDEgMy4zbC0yLjYgMC4zLTEuOC0yLjFjMCAwLTIuNy0xLjYtMy4xLTEuNi0wLjQgMC0yLjYtMC4yLTMuNC0wLjFDNDgxLjkgNDcxLjggNDc5LjIgNDcyIDQ3OS4yIDQ3MnptLTEwLjUtMTFjMC0wLjMgMC40LTIgMC44LTIuNCAwLjMtMC41LTEgMS4zIDEuNS0yLjIgMC40LTAuNiAyLjMtMi4yIDEuOS0xLjctMC42IDAuOC0xLjcgMy4yLTEuOCAzLjQtMC4yIDAuMi0wLjQgMS45LTAuNiAyLjctMC4zIDEuNiAwLjggMy4yIDAuNyAzLjktMC4xIDAuNy0yLjIgMS0yLjgtMC42QzQ2OCA0NjIuNyA0NjkgNDYxLjEgNDY5IDQ2MS4xem0yLjgtMC41Yy0wLjEtMC4zIDAtMiAwLjMtMi41IDAuMy0wLjUtMC43IDEuNSAxLTIuNSAwLjMtMC42IDEuNC0yLjcgMS41LTIgMC4xIDAuNy0wLjUgNC4yLTAuNiA0LjQtMC4xIDAuMi0wLjUgMS4zLTAuNSAyLjEgMCAwLjggMCAyLjYgMC4xIDMuMyAwLjEgMC43LTAuNiAxLjctMS41IDAuM0M0NzEuMiA0NjIuNCA0NzEuOCA0NjAuNiA0NzEuOCA0NjAuNnptLTIgMi43Yy0wLjEtMC41IDAtMy41IDAuNS00LjQgMC40LTAuOSAxLjUtMi41IDIuMi0zLjUgMC43LTEgMi0yLjcgMi4yLTEuNSAwLjEgMS4yLTAuOCA0LjUtMSA0LjktMC4yIDAuNC0wLjkgMi4zLTAuOSAzLjYtMC4xIDEuNCAzLjEgMTAuNCAzLjIgMTEuNiAwLjEgMS4yLTAuNyAzLTIuOSAxLjFDNDY0LjEgNDY3LjUgNDY5LjkgNDYzLjIgNDY5LjkgNDYzLjJ6bTE5LjctMTNjMCAwIDMuOSAwLjggNS40IDQuNiAxLjQgMy45IDIuNyA3IDEuMSAxMS44LTEuNiA0LjgtMy4yIDcuOS0zLjIgNy45IDAgMCAwLjQtMTEuOSAwLjMtMTMuOEM0OTIuOSA0NTguOSA0ODkuNiA0NTAuMyA0ODkuNiA0NTAuM1oiIGNsaXAtcGF0aD0idXJsKCNjbGlwUGF0aDQ4MjUtOCkiIG1hc2s9Im5vbmUiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC0xNjMuNDQ3MjQsMTYuNjc5ODAyKSIgc3R5bGU9ImZpbGw6I2ZmZjtmaWx0ZXI6dXJsKCNmaWx0ZXI0Nzc2LTUpO29wYWNpdHk6MCIvPjxwYXRoIGQ9Im0zMjcuNiA0ODAuMyAxMC4zLTEzLjcgMy4yIDMuMSAyLjMtMTQuNC0xMyA2LjQgMy43IDIuMWMwIDAtNC44IDYuNC0xMCAxMy40IiBpZD0icGF0aDM4OTUtNi02LTctNC00LTAtMi0wIiBmaWxsPSJub25lIi8+PHJlY3QgaWQ9InJlY3Q1NDY1LTUtOCIgd2lkdGg9IjU3LjQiIGhlaWdodD0iNTcuNCIgeD0iMjk1LjEiIHk9IjQ1NC41IiBzdHlsZT0iZmlsbDpub25lO29wYWNpdHk6MCIvPjxnIGlkPSJnMzk2Ni0yIiB0cmFuc2Zvcm09Im1hdHJpeCgwLjk5OTkwMDk2LDAuMDE0MDczODgsLTAuMDE0MDczODgsMC45OTk5MDA5NiwtMjQ1LjEwMTU3LC0yMDEuNzAwMjgpIiBjbGlwLXBhdGg9InVybCgjY2xpcFBhdGg0MTQ0KSI+PHBhdGggaWQ9InBhdGgzODk1LTYtNi03LTQtNi04LTQtNCIgZD0ibTU5Ny43IDY0OS4xLTEyLjkgNi4zIDMuNyAyLjFjMCAwLTIwIDI2LjYtMjQuNSAzMi44bC05LjEgNCA4IDEuNEw1OTcuNyA2NDkuMVoiIGZpbGw9InVybCgjbGluZWFyR3JhZGllbnQzOTcwLTYpIi8+PHBhdGggaWQ9InBhdGgzODk1LTYtNi03LTQtNi04LTQtNS04IiBkPSJtNTk3LjcgNjQ5LjEtMi40IDE0LjItMy4xLTIuOWMwIDAtMTkuOSAyNi43LTI0LjYgMzIuOGwtMS4zIDkuOS0zLjYtNy4zTDU5Ny43IDY0OS4xWiIgZmlsbD0idXJsKCNsaW5lYXJHcmFkaWVudDQxMTEpIi8+PC9nPjwvZz48L3N2Zz4=);
        width: 64px;
        height: 64px;
        display: inline-block;
        vertical-align: text-bottom;
    }
    </style>
    <script>
	function openLink(e, href) {
   	   e.preventDefault();
	   window.location.href=href;
	}
    </script>
  </head>
  <body>
    <div class="container">
        <div class="row">
            <div class="col-xs-12">
                <h1>
                    <span class="qgis-logo" height="32" title="QGIS LOGO" alt="QGIS LOGO"></span>
                 QGIS Server Explorer</h1>
                 <h2><xsl:value-of select="//wms:Service/wms:Title"/></h2>
                 <p><xsl:value-of select="//wms:Service/wms:Abstract"/></p>
                    <div id="layers">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Title</th>
                                    <th>&#160;</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:variable name="getmap" select="//wms:GetMap//wms:OnlineResource/@xlink:href" />
                                <xsl:apply-templates select="//wms:Capability">
                                    <xsl:with-param name="getmap" select="$getmap" />
                                </xsl:apply-templates>
                            </tbody>
                        </table>
                    </div>
            </div>
            <footer class="footer">
                <div class="container">
                &#169; 2016 - Alessandro Pasotti - <a href="http://www.itopen.it">ItOpen</a>
                </div>
            </footer>
        </div>
    </div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
  </body>
</html>
</xsl:template>


<xsl:template match="//wms:Capability">
    <xsl:param name="getmap"/>
    <xsl:for-each select="//wms:Layer/wms:Layer">
    <!--stick to 4326, inverted axis -->
    <xsl:variable name="CRS" select="wms:BoundingBox[@CRS='EPSG:4326']/@CRS" />
    <xsl:variable name="maxy" select="wms:BoundingBox[@CRS='EPSG:4326']/@maxx" />
    <xsl:variable name="maxx" select="wms:BoundingBox[@CRS='EPSG:4326']/@maxy" />
    <xsl:variable name="miny" select="wms:BoundingBox[@CRS='EPSG:4326']/@minx" />
    <xsl:variable name="minx" select="wms:BoundingBox[@CRS='EPSG:4326']/@miny" />
    <xsl:variable name="layers" select="wms:Title"/>
    <tr>
        <td class="level{count(ancestor::wms:Layer)}"><xsl:value-of select="$layers"/></td>
        <td><xsl:value-of select="wms:Title"/></td>
        <td><a href="{$getmap}&amp;SERVICE=WMS&amp;REQUEST=GetMap&amp;FORMAT=application/openlayers&amp;LAYERS={$layers}&amp;CRS=EPSG:4326&amp;BBOX=" class="btn btn-default" onclick="openLink(event, this.href+ ('{$CRS}' ? '{$minx},{$miny},{$maxx},{$maxy}' : '-180,-90,180,90'))">View</a></td>
    </tr>
    </xsl:for-each>
</xsl:template>



</xsl:stylesheet>
