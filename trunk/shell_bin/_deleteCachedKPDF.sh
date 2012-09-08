#!/bin/sh

IFS='
'
for n in `ls  -rlt ~/.kde/share/apps/okular/docdata/ | head -50 | awk '{print $9}'`; do 
    rm -f ~/.kde/share/apps/okular/docdata/$n; 
    #echo "rm -f ~/.kde/share/apps/okular/docdata/$n"
done

