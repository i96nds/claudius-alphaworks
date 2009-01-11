#!/bin/bash

FILE=$1
TMPOUT=$$

expand -t 4 $FILE > $TMPOUT
diff=`diff -bB $FILE $TMPOUT`x

if [ $diff != "x" ] ; then
    echo "Erro na conversao do arquivo..."
else
    mv $TMPOUT $FILE
fi


