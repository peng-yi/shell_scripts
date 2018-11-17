#!/bin/sh

if [ $# -ne 4 ]
then
   echo "$(basename $0) number1 number2 label"
   exit 1
fi

T0=700
dT=100
label=$3

for ((i=$1; i<=$2; i++))

do
   Tm=$((T0+(i-$1)*dT))

   mkdir run$i

   cd /$PWD/run$i
   cp /$PWD/../*.mod ./
   cp /$PWD/../in.melting ./
   cp /$PWD/../cuzr* ./
   cp /$PWD/../job.scr ./
   cp /$PWD/../data.lmp ./

   file="in.melting"
   sed -i "s/#runid/$i/g" $file
   sed -i "s/#Tm/$Tm.0/g" $file

   file="job.scr"
   sed -i "s/#runid/$i/g" $file
   sed -i "s/#label/$label/g" $file

   qsub job.scr

   cd /$PWD/../

done
