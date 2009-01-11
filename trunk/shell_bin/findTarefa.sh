find . -type f | while read i
  do
      file $i
      ls -i $i
      wc -l $i
  done
