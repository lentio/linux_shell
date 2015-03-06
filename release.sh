#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Usage: $0 new_attr_txt_md5sum"
    exit
fi

# update http://release.com/ver.txt
url=http://release.com/ver.txt
verfile="ver.txt"
now=$(date "+%Y%m%d")
bakfile=$verfile.$now
testfile=test.$now.txt

mv ./data/$verfile ./data/$bakfile
cp $verfile ./data/$verfile
md5sum ./data/$verfile

#verify new ver.txt
wget $url -O $testfile -q
check=$(md5sum $verfile | awk '{print $1}') 
echo "$check  $url"

#manual check content of ver.txt
tail -n 10 $testfile
rm $testfile

#auto check matched!
if [ $1 != $check ]; then
    echo "VerAttr.txt dismatched,abort!"
    exit
fi

#start to release new Version
