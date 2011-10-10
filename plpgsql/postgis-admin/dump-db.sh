#!/bin/bash

#See original idea: http://conocimientoabierto.es/comentario-diseno-bases-de-datos-postgis/360/

server=$1
user=$2
db=$3
file_db=$4
file_geometry_columns=$5

pg_dump --no-owner -N public -h $server -U $user -W -f $file_db $db
pg_dump --no-owner -a -t geometry_columns -h $server -U $user -W -f $file_geometry_columns $db