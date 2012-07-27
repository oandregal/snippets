#!/bin/bash

. db_config

dropdb -h $lrs_host -p $lrs_port -U $lrs_user $lrs_dbname
createdb -h $lrs_host -p $lrs_port -U $lrs_user -w -O $lrs_owner -T $lrs_template $lrs_dbname

# Create DB
psql -h $lrs_host -p $lrs_port -U $lrs_user \
    $lrs_dbname < functions/01-lrs-db-structure.sql
psql -h $lrs_host -p $lrs_port -U $lrs_user \
    $lrs_dbname < functions/02-lrs-db-data.sql
psql -h $lrs_host -p $lrs_port -U $lrs_user \
    $lrs_dbname < functions/03-lrs-dynamic-segmentation.sql

