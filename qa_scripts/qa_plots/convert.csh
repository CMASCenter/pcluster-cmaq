#!/bin/csh
  
foreach name (`ls *.pdf`)
  set name2=`basename $name .pdf`
  echo $name
  echo $name2
  pdftoppm -jpeg -r 600 $name $name2
end
