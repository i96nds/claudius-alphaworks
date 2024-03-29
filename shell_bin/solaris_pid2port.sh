#!/bin/ksh
#
# 7-30-2003
# find from a port the pid that started the port
#
line='-------------------------------------------------------------------------'
pids=`/usr/bin/ps -ef | sed 1d | awk '{print $2}'`

# Prompt users or use 1st cmdline argument
if [ $# -eq 0 ]; then
         read ans?"Enter port you like to know pid for:  "
else
         ans=$1
fi

# Check all pids for this port, then list that process
for f in $pids
do
         /usr/proc/bin/pfiles $f 2>/dev/null | /usr/xpg4/bin/grep -q "port: $ans"
         if [ $? -eq 0 ] ; then
                 echo "$line\nPort: $ans is being used by PID: \c"
                 /usr/bin/ps -o pid -o args -p $f | sed 1d
         fi
done
exit 0

