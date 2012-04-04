#!/bin/bash

# @author: Andres Maneiro <andres.maneiro@gmail.com>
# @license: GPL v3

# Create a workspace in geoserver. Previously, delete it if exists.

geoserver_uri=$1
workspace_name=$2

echo -n "Geoserver user:"
read -s user
echo "" # trick to get new line
echo -n "Geoserver passwd:"
read -s passwd

# Delete workspace if exists
echo " * Deleting workspace "$workspace_name
curl -u $user:$passwd -v -XDELETE ${geoserver_uri}/rest/workspaces/${workspace_name}

# Create workspace
echo " * Creating workspace "$workspace_name
curl -u $user:$passwd -v -XPOST -H 'Content-type: text/xml' \
    -d '<workspace><name>'$workspace_name'</name></workspace>' ${geoserver_uri}/rest/workspaces

