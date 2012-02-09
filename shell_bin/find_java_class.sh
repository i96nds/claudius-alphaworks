#!/bin/bash
# por claudio@claudius.com.br

usage="Uso:        findJavaClass directory ClassName   "
IFS='
'
dir=${1}
class=$2

if [ $# -lt 2 ] ; then
    echo $usage
    exit 1
fi

if [ ! -d "$dir" ] ; then
    echo "Diretorio nao existe"
    exit 1    
#elif [ -e "$dir" ] ; then
#    unzip -l "$dir" | grep --color "$class"
#    exit
fi

if [ -d $dir ] ; then
  find -L "$dir" -type f  -name \*ar | while read jar_file ; 
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
  find -L $dir -wholename \*$class\* | grep --color  $class

fi


