#!/bin/bash

# @author: Andres Maneiro <andres.maneiro@gmail.com>
# license: GPL v3

projects=(addons-manager andami appgvSIG binaries \
    extCAD extJCRS extJDBC extScripting extSymbology \
    extWMS libCorePlugin libDriverManager libExceptions \
    libFMap libGDBMS libInternationalization libIverUtiles \
    libJCRS libProjection libUIComponent)

rm -rf /tmp/workspace-from-scratch/
mkdir /tmp/workspace-from-scratch
cd /tmp/workspace-from-scratch/
git init
echo "Base workspace" > README
git add README
git commit -m "Initial commit"

for p in "${projects[@]}"; do

    lowercase_p=`echo ${p,,}`
    local_remote="gvsig-${lowercase_p}"
    local_branch="br-${local_remote}"

    if [ $p = "addons-manager" ]; then
        local_dir="org.gvsig.installer.app.extension"
    elif [ $p = "andami" ]; then
        local_dir="_fwAndami"
    else
        local_dir=$p
    fi

    echo "- remote: $local_remote"
    echo "  branch: $local_branch"
    echo "  dir:    $local_dir"

    git remote add $local_remote git://gitorious.org/gvsig-desktop/${p}.git
    git fetch $local_remote
    git checkout -b $local_branch ${local_remote}/master
    git checkout master
    git read-tree --prefix=$local_dir -u $local_branch

done

git commit -m "gvSIG workspace done!"
