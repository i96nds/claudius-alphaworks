#!/bin/bash

if [ $# -lt 1 ] ; then
    echo "Usage: "
    echo "     threads_per_process.sh PID | process name [count] "
    echo ""
    echo "Example"
    echo "  PID: 36434 or"
    echo "  process string: NumThreads (this script will do a ps -ef|grep NumThreads to get the PID)" 
    echo "  The last number is the number of times the command will run"
    echo ""
    echo "     threads_per_process.sh 36434 20"
    echo "     threads_per_process.sh 36434 "
    echo "     threads_per_process.sh NumThreads"
    echo "     threads_per_process.sh NumThreads 20"
    echo ""
    exit 1
fi

echo "========================================================"
echo "The number of threads is displayed under the column NLWP"
echo "========================================================"

COUNT=1
if [ $# -gt 1 ] ; then
    COUNT=$2
fi

PATTERN=`echo $1 | sed 's/[0-9]//g'`
PROCESS_ID=$1

if [ ! -z $PATTERN  ] ; then
    # string
    PROCESS_ID=`ps -ef |egrep -v 'grep|threads_per' |grep $1|awk '{print $2}'`
    echo "The PID to lookup is: "$PROCESS_ID
fi

CMD="ps -p $PROCESS_ID -o pid,user,%cpu,rss,vsize,size,etime,nlwp,args"
CMD2="ps -p $PROCESS_ID h -o pid,user,%cpu,rss,vsize,size,etime,nlwp,args"

#echo "PATTERN = $PATTERN"
#echo "PROCESS_ID = $PROCESS_ID"
#echo "COUNT = $COUNT"
#echo "CMD = $CMD"
PATTERN=`echo $PROCESS_ID | sed 's/\ /@/g' | sed 's/[0-9]//g'`

HEADER_COUNT=15
if [ -z $PATTERN ] ; then
    if [ $COUNT -gt 1 ] ; then
        for n in `seq 1 $COUNT`; do 
            PROCESS_ID=`ps -e |awk '{print $1}' | grep $PROCESS_ID`
            if [ -z $PROCESS_ID  ] ; then
                echo "The monitored PID no longer exists. Exiting."
                exit 0;
            fi
            if [ $HEADER_COUNT == 0 ] ; then
                HEADER_COUNT=15
            fi
            if [ $HEADER_COUNT == 15 ]; then
                eval $CMD
            else
                eval $CMD2
            fi
            HEADER_COUNT=`echo $HEADER_COUNT-1 | bc`
            sleep 1;
        done
    else
        eval $CMD
    fi
else
    echo "The keyword \"$1\" return more than one PID. Please consider constraining the keyword"
fi 

