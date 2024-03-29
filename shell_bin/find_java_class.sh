#!/bin/bash
# por claudio@claudius.com.br

usage="Uso:       $0 directory ClassName   "
IFS='
'
path=${1}
class=`echo $2 |sed 's/\.class/CLASS/g'`
class=`echo $2 |sed 's/\./\//g'`
class=`echo $2 |sed 's/CLASS/\.class/g'`

if [ $# -lt 2 ] ; then
    echo $usage
    exit 1
fi

if [ ! -d "$path" ] ; then
    echo "Diretorio nao existe"
    exit 1    
#elif [ -e "$path" ] ; then
#    unzip -l "$path" | grep --color "$class"
#    exit
fi

if [ -d $path ] ; then
  find -L "$path" -type f  -name \*ar | while read jar_file ; 
  do
      found_class=`unzip -l $jar_file | awk '{print $4}' | grep $class`
      num_classes=`echo $found_class | wc -c`
      if [ $num_classes -gt 1 ] ; then 
          echo ""
          echo "Arquivo:"
          echo "    $jar_file"
          echo "Classes:"
          echo $found_class | sed 's/\ /\n/g' | sed 's/^.*/\ \ \ \ &/g' | grep --color $class
      fi
  done

  echo ""
  find -L $path -wholename \*$class\* | grep --color  $class

fi



