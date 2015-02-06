#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

mydir=$(cd $(dirname $0);pwd)
appdir=${mydir}/bin
echo $appdir

RED="\\e[1m\\e[31m"

#spp main program name should be renamed since many app may run in same server
appname="daemon_server"

service_status()
{
    pidcnt=$(ps -ef|grep "${appname}"|grep -v grep|wc -l)
    pids=$(ps -ef|grep "./${appname}"|grep -v grep|awk '{print $2}')
    if [ ${pidcnt} -lt 1 ];then
        echo "program ${appname} is stoped."
    else
    echo "program ${appname}(${pids}) is running."
    fi
}

service_start()
{
    #start appname, it can handle the situation that same appname reside on one host
    pidcnt=$(ps -ef|grep "${appname}"|grep -v grep|wc -l)
    pids=$(ps -ef|grep "${appname}"|grep -v grep|awk '{print $2}')
    if [ ${pidcnt} -lt 1 ];then
        cd ${appdir}/;
        ./${appname} ${spp_ctrl_confname}
    else
        for pid in ${pids};do
            run_exe=$(readlink /proc/${pid}/exe | awk '{print $1}')
            if [ -n "${run_exe}" ];then
                local_exe=${appdir}/${appname}
                if [ ${run_exe} -ef ${local_exe} ];then
                    echo "program ${appname} already started."
                    return
                fi
            fi
        done
        ./${appname}
    fi
}

service_stop()
{
    #stop appname, it can handle the situation that same appname reside on one host
    pidcnt=$(ps -ef|grep "./${appname}"|grep -v grep|wc -l)
    pids=$(ps -ef|grep "./${appname}"|grep -v grep|awk '{print $2}')
    if [ ${pidcnt} -lt 1 ];then
        echo "no program ${appname} killed."
    else
        for pid in ${pids};do
            run_exe=$(readlink /proc/${pid}/exe | awk '{print $1}')
            if [ -n "${run_exe}" ];then
                kill -10 ${pid}
            fi
        done
        sleep 1
        rm -rf /tmp/mq_comsumer_*.lock
        echo "program ${appname} stoped."
    fi
}

service_force_stop()
{
    pids=$(ps -ef | egrep "${appname}" |grep -v grep|awk '{print $2}')
    for pid in ${pids};do
        run_exe=$(readlink /proc/${pid}/exe | awk '{print $1}')
        local_exe=${appdir}/${appname}
        if [ ${run_exe} -ef ${local_exe} ]
        then
            kill -9 $pid
            continue
        fi
    done
    echo "program force stoped."
}

case $1 in
    status)
    service_status
    ;;
    stop)
    echo "Service STOPING.........."
    service_stop
    ;;
    start)
    echo "Service STARTING........."
    service_start
    sleep 1
    service_status
    ;;
    restart)
    echo "Service RESTARTING......."
    service_stop
    sleep 2
    service_force_stop
    service_start
    sleep 1
    service_status
    ;;
    force_stop)
    echo "Service FORCE STOPING......."
    service_force_stop
    ;;
    force_restart)
    echo "Service FORCE RESTARTING......."
    service_force_stop
    sleep 2
    service_start
    sleep 1
    service_status
    ;;
    *)
    echo "Usage: $0 { stop | start | status | restart | force_stop | force_restart}"
esac

exit 0
