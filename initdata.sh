#!/bin/sh
# updated: 7/2/2016

if [ $# -ne 2 ]
then 
   echo "$(basename $0) number1 number2"
   exit 1
fi

for ((i=$1; i<=$2; i++))

do

   ./a.out > create.log

   #bash replace.sh data.lmp

   path="/$HOME/scratch/Ni-Al/nucleation/small3/cr5e10/run$i/"
   cp data.lmp create.log $path
   sleep 1

done
