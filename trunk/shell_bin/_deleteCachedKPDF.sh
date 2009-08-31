#!/bin/sh

IFS='
'
for n in `ls  -rlt ~/.kde/share/apps/kpdf/ | head -40 | awk '{print $8}'`; do 
    #rm -f ~/.kde/share/apps/kpdf/$n; 
    $( echo "$n" ) 
done

