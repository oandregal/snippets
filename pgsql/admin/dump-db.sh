#!/bin/bash

# @author: Andrés Maneiro <andres.maneiro@gmail.com>
# @license: GPL v3

#See original idea: http://conocimientoabierto.es/comentario-diseno-bases-de-datos-postgis/360/

server=$1
user=$2
db=$3
file_db=$4
file_geometry_columns=$5

pg_dump --no-owner -v -N public -h $server -U $user -W -f $file_db $db
pg_dump --no-owner -v -a -t geometry_columns -h $server -U $user -W -f $file_geometry_columns $db
