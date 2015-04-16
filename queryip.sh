#!/bin/sh
if [ $# -ne 1 ]; then
     echo "Usage：$0 <IP>"
     echo "       Get network quality statistics from the designed IP addr for the last 1 hour."
     echo "Result format:"
     echo "       idc_index rx_rate delay_time tx_pkgs" 
     exit 1
fi

ip=$1
app_tool=/home/oicq/lance_test/qttool
data_path=/data/qtresult/QQ
suffix=".1.QQ.dat"
now_day=`date "+%Y%m%d"`
now_hour=`date "+%H"`
#last hour file
last_hour=`expr $now_hour - 1`

#current hour file
query_hour()
{
    now="${now_day}_${1}0000"
    file=${data_path}/${now}${suffix};
    result="${ip}.result"
    $app_tool search ip ${ip} ${file} | awk '{s[$5]+=$6;r[$5]+=$7;ds[$5]+=$8}END{for(i in s)if(i%5==4)print i,r[i]/s[i],ds[i]/r[i],s[i]}' | sort -n
    return ${PIPESTATUS[0]};
}

query_hour $now_hour;
query_hour $last_hour;
