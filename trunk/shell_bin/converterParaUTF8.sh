#!/bin/sh

if [ $# -lt 1 ] ; then
    echo ""
    echo " Informe um diretório para converter os arquivos .java para UTF-8"
    exit 1
fi

find . -name \*.java -exec file {} \; | grep 8859 | while read s; do 
	ff=`echo $s | awk -F ':' '{print $1}'`;   
	konwert cp1252-utf8 -O  $ff; 
done                      
