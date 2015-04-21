#!/bin/sh
show_usage()
{
     echo "Usage：$0 ip <IP>"
     echo "       Get network quality statistics from the designed IP addr for the last 1-2 hour."
     echo "       $0 ipc <Gateway_IP>"
     echo "       Get network quality statistics from the gateway of designed IP addr for the last 1-2 hour."
     echo "Result format:"
     echo "       idc_index rx_rate delay_time tx_pkgs"
     exit 1;
}

query_hour()
{
    app_tool=/home/tool/query.sh
    data_path=/data/
    suffix=".dat"

    now="${1}0000"
    file=${data_path}/${now}${suffix};
    result="${ip}.result"
   
    #echo "$app_tool search ip ${ip} ${file} | awk '{s[$5]+=$6;r[$5]+=$7;ds[$5]+=$8}END{for(i in s)if(i%5==4)print i,r[i]/s[i],ds[i]/r[i],s[i]}' | sort -n" 
    $app_tool search ${mode} ${ip} ${file} | awk '{s[$5]+=$6;r[$5]+=$7;ds[$5]+=$8}END{for(i in s)if(i%5==4)print i,r[i]/s[i],ds[i]/r[i],s[i]}' | sort -n
    return ${PIPESTATUS[0]};
}

exec_query()
{    
    now_hour=`date "+%Y%m%d_%H"`
    last_hour=`date "+%Y%m%d_%H" -d "-2 hour"`

    query_hour $now_hour;
    if [ $? -ne 0 ]; then
        echo "error"
        exit 1;
    fi

    query_hour $last_hour;
    if [ $? -ne 0 ]; then
        echo "error"
        exit 1;
    fi

    exit 0;
}

#############################
if [ $# -lt 2 ]; then
    show_usage;
fi

mode=$1
ip=$2

if [ $mode == "ip" ];  then
    exec_query;
elif [ $mode = "ipc" ]; then
    exec_query;
else
    show_usage;
fi
