#!/bin/sh
svn_url=http://svn.url/pub/pub_rep/proj
proj=project
current_date=`date "+%Y%m%d"`
proj_tags=${proj}_${current_date}

echo "tag is :  ${proj_tags}"

echo "svn copy ${svn_url}/trunk ${svn_url}/tags/${proj_tags}"

svn copy ${svn_url}/trunk ${svn_url}/tags/${proj_tags}
