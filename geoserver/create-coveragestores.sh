#!/bin/bash

# @author: Andres Maneiro <andres.maneiro@gmail.com>
# @license: GPL v3

# Take all tif files in a directory and add coveragestores and the correspondt layer to it
# In order to minimize the time it takes to register a file, the script will be executed from the same server than geoserver. For a full discussion:
# http://jira.codehaus.org/browse/GEOS-3966
# http://jira.codehaus.org/secure/attachment/49082/document_url_and_external_coverage_uploads.patch
# http://docs.geoserver.org/stable/en/user/restconfig/index.html

geoserver_uri=${1}
user=${2}
passwd=${3}
workspace=${4}
root_directory=${5}

for i in `find ${root_directory} -name *tif`;
do

 file=$i
 store=`basename $i .tif`
 layer=`basename $i .tif`

 echo " --- Store / Layer $store"
 #echo "     Layer $layer"
 echo "     File $file"

 # CREATE COVERAGESTORE
 curl -u $user:$passwd -v -XPOST -H 'Content-Type: application/xml' -d '<coverageStore><name>'$store'</name><workspace>'$workspace'</workspace></coverageStore>' ${geoserver_uri}/rest/workspaces/$workspace/coveragestores
 echo "     * CoverageStore created: $store"

 # ADD LAYER TO COVERAGESTORE
 curl -u $user:$passwd -v -XPUT -H 'Content-Type: text/plain' -d 'file:'${file} ${geoserver_uri}/rest/workspaces/$workspace/coveragestores/$store/external.geotiff?configure=first\&coverageName=$store
 echo "     * Layer added to coveragestore"

 # ENABLE LAYER BUT NOT ADVERTISING IT
 # it's not possible to set SRS from REST, so enable the layer is wasteful without that. At least, with the layer I've tested, which geoserver didn't recognize the SRS.
 curl -u $user:$passwd -v -XPUT -H 'Content-Type: text/xml' -d '<layer><metadata><entry key="advertised">false</entry></metadata><enabled>true</enabled></layer>' ${geoserver_uri}/rest/layers/$layer
 echo "     * Layer enabled & *not* advertised"

 # ENABLE COVERAGE
 # after adding the layer, and if it has right SRS, it's possible to enable the store
 curl -u $user:$passwd -v -XPUT -d '<coverageStore><name>'$store'</name><enabled>true</enabled></coverageStore>' -H "Content-Type: text/xml" ${geoserver_uri}/rest/workspaces/$workspace/coveragestores/$store.xml
 echo "     * CoverageStore enabled"

done
