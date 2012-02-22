#!/usr/bin/python

# @author Andres Maneiro <andres.maneiro@gmail.com>
# @license GPL v3

import sys

from fiona import collection

from shapely.geometry import mapping, shape

input_file = sys.argv[1]
output_file = sys.argv[2]

with collection(input_file, "r") as input:
    schema = input.schema.copy()
    schema['geometry'] = 'Point'

    with collection(output_file, "w", "ESRI Shapefile", schema) as output:

        for f in input:
            geom = shape(f['geometry'])
            point = geom.centroid
            point.geom_type == 'Point'
            f['geometry'] = mapping(point)
            output.write(f)
