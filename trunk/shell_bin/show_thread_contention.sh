#!/bin/bash

for n in "$1" ; do 
  echo "---> $n" 
  grep "waiting to lock" $n | sort -k2 -r | uniq -c |sort -k1 -n -r; 
done
