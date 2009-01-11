#!/bin/bash
[[ $2 ]] || { echo "Uso: ${0} diretorio classe" ; exit 1 ; }
find "${1}" -name \*.jar -print | xargs -n 1 unzip -l 2>&- | awk -v class="${2}" '
        BEGIN       { IGNORECASE=1                                     }
        /^Archive/  { file="\nArquivo:\n\t"$NF": \nClasses:\n\t"       }
        /class$/ && $NF ~ class { print file,$NF ; file="\t"; total++  }
        END         { print "\nTotal",total + 0,"classes encontradas!" }'
