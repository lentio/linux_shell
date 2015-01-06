#!/bin/bash
if [ $# -ne 1 ]; then
        echo "Usage: $0 project_name"
        exit
fi

local_path="prj_$1"
mkdir $local_path

if [ $? -ne 0 ]; then
        echo "Fail to mkdir $local_path!"
        exit
fi

prj_svn=$svn_url_trunk
echo "svn checkout  $prj_svn into $local_path"

svn checkout $prj_svn $local_path
