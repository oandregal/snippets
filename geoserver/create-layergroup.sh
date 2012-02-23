#!/bin/bash

# @author: Andres Maneiro <andres.maneiro@gmail.com>
# @license: GPL v3

# Create a layergroup in geoserver through REST API.
#
# REST @ geoserver:
# http://docs.geoserver.org/stable/en/user/restconfig/index.html
# http://jira.codehaus.org/browse/GEOS-3966
# http://jira.codehaus.org/secure/attachment/49082/document_url_and_external_coverage_uploads.patch
#
# LAYERGROUP.XML
# It's needed to declare the group with all the layer, sent only one of them, will delete the previous configuration.
#
# Structure of layergroup.xml file:
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
#

geoserver_uri=${1}
user=${2}
passwd=${3}
layergroup_name=${4}
root_directory=${5}

for i in `find ${root_directory} -name *tif`; do
 new_layer=`basename $i .tif`
 layers="$layers $new_layer"
done

python create-xml-for-layer-group.py $layergroup_name  $layers

curl -u $user:$passwd -XPOST -d @/tmp/layergroup.xml -H 'Content-type: text/xml' ${geoserver_uri}/rest/layergroups
echo " - LayerGroup created: $layergroup_name"
