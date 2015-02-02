#!/bin/sh
obj=app
now=`date "+%Y%m%d_%H"`
cnt=`ls|grep $now|wc -l`
if [ ! 1 -eq $cnt ]; then
    echo "fail to rollback, No avail backup!"
    exit 0
fi

rm $obj
cp $obj.$now $obj
./app
