#!/usr/bin/python

# @author: Andres Maneiro <andres.maneiro@gmail.com>
# @license: GPL v3

# See REST configuration at geoserver
# http://docs.geoserver.org/stable/en/user/restconfig/rest-config-api.html
# This script crafts the xml need to create a new layer group.
# The XML should look like this:
# <layerGroup>
#   <name>nyc</name>
#   <layers>
#     <layer>roads</layer>
#     <layer>parks</layer>
#     <layer>buildings</layer>
#   </layers>
#   <styles>
#     <style>raster</style>
#     <style>parks</style>
#     <style>buildings_style</style>
#   </styles>
# </layerGroup>

def newLayerBlock(layers):
    block = ' <layers>\n'
    for layer in layers:
        block = block + '  ' + newLayerNode(layer)
    block = block + ' </layers>\n'
    return block

def newLayerNode(layername):
    return '<layer>' + layername + '</layer>\n'

def newStyleBlock(styles):
    block = ' <styles>\n'
    for style in styles:
        block = block + '  ' + newStyleNode(style)
    block = block + ' </styles>\n'
    return block

def newStyleNode(style):
    return '<style>' + style + '</style>\n'

def newLayerGroupName(layer_group_name):
    return '<name>' + layer_group_name + '</name>\n'

def createXML(layer_group_name, layers, styles):
    xml = '<layerGroup>\n'
    xml = xml + newLayerGroupName(layer_group_name)
    xml = xml + newLayerBlock(layers)
    xml = xml + newStyleBlock(styles)
    xml = xml + '</layerGroup>\n'
    return xml

if __name__ == "__main__":
    import sys
    layer_group_name = sys.argv[1]
    layers = sys.argv[2:]
    styles = []
    for layer in layers:
        styles.append("raster")
    xml = createXML(layer_group_name, layers, styles)
    file = open('./layergroup.xml', 'w')
    file.write(xml)
