#!/bin/bash

# @author: Andres Maneiro <andres.maneiro@gmail.com>
# license: GPL v3

# Takes a local directory an uploads it to server
#   making backups previously.

dir_local=${1}   # Directory where retrieve info in local, ie: /tmp/foo
auth_server=${2} # Authentication user@hostname for ssh
dir_server=${3}  # Directory where to save the files in server, ie: /tmp/bar
user_group=${4}  # Remote user and group for files.

dir_server_bak=${dir_server}'_bak'
user_permission=$user_group
group_permission=$user_group

# Backup old dir if $dir_server_bak exists
command="test -d $dir_server_bak"
ssh $auth_server $command && \
    dir_bak_baked="${dir_server_bak}-`date +%Y%m%d`-`date +%H%M` "
    echo -e "\n* $dir_server_bak being moved to $dir_bak_baked ..." && \
    command="sudo mv $dir_server_bak $dir_bak_baked" && \
    ssh -t $auth_server $command

# Backup dir if $dir_server exists
command="test -d $dir_server"
ssh $auth_server $command && \
    echo -e "\n* $dir_server being moved to $dir_server_bak ..." && \
    command="sudo mv $dir_server $dir_server_bak " && \
    ssh -t $auth_server $command

# Upload files
echo -e "\n* Uploading files ..."
scp -r $dir_local ${auth_server}:'/tmp/mytmpdir'
command="sudo mv /tmp/mytmpdir $dir_server "
ssh -t $auth_server $command

echo -e "\n* Changing permissions ..."
command="sudo chown -R ${user_permission}:${group_permission} $dir_server"
ssh -t $auth_server $command

