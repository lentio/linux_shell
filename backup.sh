#!/bin/sh
obj=app
now=`date "+%Y%m%d_%H%M%S"`
mv $obj $obj.$now
tar -xzf $obj.tar.gz 
./app restart
