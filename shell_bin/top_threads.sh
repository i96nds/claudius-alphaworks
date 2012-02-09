#!/bin/bash

PID=$1
IFS=''

java_stack=`jstack -l $PID` 
ps  -p $PID -o pid,lwp,%cpu,s,rss,etime  | head -1
ps  -L h -p $PID -o pid,lwp,%cpu,s,rss,etime  | sort -r -n -k 3 | head -5
ps  -L h -p $PID -o pid,lwp,%cpu,s,rss,etime  | sort -r -n -k 3 | head -5 | while read psline; do 
  lwp_id=`echo $psline | awk '{print $2}'` 
  nid=`printf '%x\n' $lwp_id ` 
  echo "========> Java LWP: $lwp_id - Native Thread ID=$nid"
  echo $java_stack | sed -n "/$nid/,/^$/ p" ;   
done
