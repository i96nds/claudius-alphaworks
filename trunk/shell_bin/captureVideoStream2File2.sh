#!/bin/sh


echo "Download da URL: "$1
echo ""
rtsp_file=`links -dump $1 | grep rtsp`
mplayer -dumpstream  $rtsp_file -dumpfile $2
