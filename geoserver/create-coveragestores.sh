#!/bin/bash

# @author: Andres Maneiro <andres.maneiro@gmail.com>
# @license: GPL v3

# Take all tif files in a directory and add coveragestores and the correspondt layer to it
# In order to minimize the time it takes to register a file, the script will be executed from the same server than geoserver. For a full discussion:
# http://jira.codehaus.org/browse/GEOS-3966
# http://jira.codehaus.org/secure/attachment/49082/document_url_and_external_coverage_uploads.patch
# http://docs.geoserver.org/stable/en/user/restconfig/index.html

user=${1}
passwd=${2}
workspace=${3}
#store='name'
#file='name.tif'
#layer='name'

for i in `ls *.tif`;
do

 file=$i
 store=`basename $i .tif`
 layer=`basename $i .tif`

 # CREATE COVERAGESTORE
 curl -u $user:$passwd -v -XPOST -H 'Content-Type: application/xml' -d '<coverageStore><name>'$store'</name><workspace>'$workspace'</workspace></coverageStore>' http://localhost:8000/geoserver/rest/workspaces/$workspace/coveragestores
 echo "---------------- COVERAGESTORE CREATED"

 # ADD LAYER TO COVERAGESTORE
 curl -u $user:$passwd -v -XPUT -H 'Content-Type: text/plain' -d 'file:/system/path/to/file/'$file http://localhost:8000/geoserver/rest/workspaces/$workspace/coveragestores/$store/external.geotiff?configure=first\&coverageName=$store
 echo "---------------- LAYER ADDED TO COVERAGESTORE"

 # ENABLE LAYER
 # it's not possible to set SRS from REST, so enable the layer is wasteful without that. At least, with the layer I've tested, which geoserver didn't recognize the SRS.
 #curl -u $user:$passwd -v -XPUT -H 'Content-Type: text/xml' -d '<layer><enabled>true</enabled></layer>' localhost:8000/geoserver/rest/layers/$layer
 #echo "---------------- LAYER ENABLED"

 # ENABLE COVERAGE
 # after adding the layer, and if it has right SRS, it's possible to enable the store
 curl -u $user:$passwd -v -XPUT -d '<coverageStore><name>'$store'</name><enabled>true</enabled></coverageStore>' -H "Content-Type: text/xml" http://localhost:8000/geoserver/rest/workspaces/$workspace/coveragestores/$store.xml
 echo "---------------- COVERAGESTORE ENABLED"

done
