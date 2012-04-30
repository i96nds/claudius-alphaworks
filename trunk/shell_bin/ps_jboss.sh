#!/bin/bash
# by claudio@claudius.com.br

# JBoss 5 detector
ps -ef  | grep org.jboss.Main|grep -v grep |
while read psline; do 
  pid=`echo $psline | awk '{print $2}'` 
  prc_name="EAP 5 - "`echo $psline | awk  -F ' -c ' '{ print $2}' `
  info_prc=`ps -o nlwp,etime h $pid`
  nlwp=`echo $info_prc|awk '{print $1}'`
  etime=`echo $info_prc|awk '{print $2}'`
  echo "$pid - $prc_name ($nlwp threads, since $etime)"
  sudo netstat -antpuew | grep -E "$pid/java" | grep LISTEN | awk '{print "\t"$1" "$4}'
  echo ""
done  


# JBossAS 7 (EAP 6) detector
ps -ef  | grep jboss-modules| grep '\-D\[' | 
while read psline; do 
  pid=`echo $psline | awk '{print $2}'` 
  prc_name=`echo $psline | awk  -F '-D' '{ print $2}' | awk -F ']' '{print $1"]"}' | sed -e 's/\[//g' -e 's/\]//g'`
  conf_name=`echo $psline | awk -F '-c ' '{print $2}'  ` 
  if [ "x" != "x"$conf_name ] ; then
    prc_name=$prc_name" ["$conf_name"]"
  fi
  echo $pid" - "$prc_name
  sudo netstat -antpuew | grep -E "$pid/java" | grep LISTEN | awk '{print "\t"$1" "$4}'
  echo ""
done
