#!/bin/bash

if [ "$1" ] && [ $1 = '-c' ] ; then
    shift
    cat $1 | while read hash_line
    do
      hash_value=`echo $hash_line | awk '{print $1}'`
      filename=`echo $hash_line | awk '{print $2}'`

      hash_var=`openssl dgst -md5 $filename | awk '{print $2}'` ;
      echo -n $filename": "
      if [ $hash_var == $hash_value ] ; then
          echo "OK"
      else
          echo "FAILED"
      fi
    done
else
    openssl dgst -md5 $*  |  sed 's/[\(\)=]//g;s/MD5//g' | awk '{print $2"  "$1}'
fi

