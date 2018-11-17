#!/bin/sh
# Repeat same operation to folders whose names contain the given string
# Peng Yi, 8/15/2018

# syntax: ./do2folders string command
#         execute command in folders whose name contain string
#  e.g.   ./do2folders "cp ../ti_solid.py ." test
#         ./do2folders "./ti_solid.py" test

operation=$1
folders=`ls -l . | egrep '^d' | awk '{print $9}' | grep $2`

for entry in $folders; do
   echo $entry

   cd /$PWD/$entry/
   #touch xxx
   $operation
   cd /$PWD/../

done
