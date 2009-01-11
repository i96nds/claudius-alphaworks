#!/bin/bash

# http://www.linux.com/articles/53702

ORIG_VIDEO=$1
MPEG_VIDEO=$1.mpeg

# NTSC
mencoder -oac lavc -ovc lavc -of mpeg -mpegopts format=dvd -vf scale=720:480,harddup \
-srate 48000 -af lavcresample=48000 \
-lavcopts vcodec=mpeg2video:vrc_buf_size=1835:vrc_maxrate=9800:vbitrate=5000:keyint=18:aspect=16/9:\
acodec=ac3:abitrate=192 -ofps 30000/1001 -o $MPEG_VIDEO $ORIG_VIDEO 
