#!/bin/bash

# @author: Andres Maneiro <andres.maneiro@gmail.com>
# @license: GPL v3

## Script to convert geotiff created by ArcGIS (tif+rrd/ovr+aux files)
## into proper geoserver-capable GeoTIFFs.
## The parameters (srs, blocksize, etc) should be changed at convenience.

src_dir=${1}
dest_dir=${2}

for i in `ls ${src_dir}/*tif`; do
    gdal_translate -a_srs "EPSG:23029" $i ${dest_dir}/`basename $i` \
        -co NBITS=1 -co TILED=yes -co BLOCKXSIZE=512 -co BLOCKYSIZE=512 ;
done

for i in `ls ${dest_dir}/*tif`; do
    gdaladdo -r average $i 2 4 8 16;
done
