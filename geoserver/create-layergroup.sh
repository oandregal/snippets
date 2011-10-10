#!/bin/bash

# @author: Andres Maneiro <andres.maneiro@gmail.com>
# @license: GPL v3

# Create a layergroup in geoserver through REST API.
# In order to minimize the time it takes to register a file, the script will be executed from the same server than geoserver. For a full discussion:
# http://jira.codehaus.org/browse/GEOS-3966
# http://jira.codehaus.org/secure/attachment/49082/document_url_and_external_coverage_uploads.patch
# http://docs.geoserver.org/stable/en/user/restconfig/index.html

# CREATE LAYER GROUP
# needs the layergroupdescription.xml file, something like:
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
# it's needed to create the group with all the layer, sent only one of them, will delete the previous configuration

user=${1}
passwd=${2}

curl -u $user:$passwd -XPOST -d @layergroup.xml -H 'Content-type: text/xml' http://localhost:8000/geoserver/rest/layergroups
echo "---------------- LAYER GROUP CREATED"
